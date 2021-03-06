//
//  TwitterClient.swift
//  twitter
//
//  Created by Grace Kotick on 6/27/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "haqRcOh1dzZBxurCF5Qv1ZfWF", consumerSecret: "Rndt3RRhlWZ3aTlFmc9BQeEkreXqHMMY95kkXyWGHQM5L15kLx")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func homeTimeline(success: ([Tweet]) -> Void, failure: (NSError) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })

    }
    
// figure out how to get just a users tweets
    func userTimeline(screenname: String, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        GET("1.1/statuses/user_timeline.json", parameters: ["screen_name": screenname], success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        
    }
    
    func retweet(id: String, success: (Tweet) -> (),  failure: (NSError) -> ()){
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            
            success(tweet)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    }
    func favorite(id: String, success: (Tweet) -> (),  failure: (NSError) -> ()){
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            
            success(tweet)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    func tweet(text: String, success: (Tweet) -> (),  failure: (NSError) -> ()){
        POST("1.1/statuses/update.json", parameters: ["status": text], success: {(task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            
            success(tweet)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            
        }, failure:  { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })

    }
    //edit here!!!!!!!!!!!!!!
    func currentUserLikes(screenname: String, success: ([Tweet]) -> (), failure: (NSError) -> ()){
        GET("1.1/favorites/list.json?screen_name=\(screenname)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure:  { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        
    }

    func login(success: () -> (), failure: (NSError) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()

        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    func logout(){
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
    fetchAccessTokenWithPath("oauth/access_token", method: "POST" , requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in

            self.currentAccount({ (user: User) -> () in
                
                User.currentUser = user
                self.loginSuccess?()
                
            }, failure: {(error: NSError) -> () in
                self.loginFailure?(error)
            })
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
}

//
//  User.swift
//  twitter
//
//  Created by Grace Kotick on 6/27/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    var backgroundUrl: NSURL?
    var dictionary: NSDictionary?
    var followers: Int?
    var following: Int?
    var statusCount: Int?
    static let userDidLogoutNotification = "UserDidLogout"
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            let modifiedProfileUrlString = profileUrlString.stringByReplacingOccurrencesOfString("_normal", withString: "_bigger")
            profileUrl = NSURL(string: modifiedProfileUrlString)
        }
        
        let backgroundUrlString = dictionary["profile_banner_url"] as? String
        if let backgroundUrlString = backgroundUrlString {
            backgroundUrl = NSURL(string: backgroundUrlString)
        }
        statusCount = dictionary["statuses_count"] as? Int
        following = dictionary["friends_count"] as? Int
        followers = dictionary["followers_count"] as? Int
        tagline = dictionary["description"] as? String
        
    }
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil{
                let defaults = NSUserDefaults.standardUserDefaults()
                
                let userData = defaults.objectForKey("currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
                
            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user{
                
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else{
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
    
}

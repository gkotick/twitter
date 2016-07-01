//
//  DetailsViewController.swift
//  twitter
//
//  Created by Grace Kotick on 6/29/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var tweet: Tweet?
    
    @IBOutlet weak var favoritesCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetLabel.text = tweet!.text as? String
        //timestampLabel.text = "\(tweet!.timestamp!)"
        
        tweetLabel.sizeToFit()
        let username = tweet!.user?.screenname as? String
        
        screennameLabel.text = "@\(username!)"
        nameLabel.text = tweet?.user?.name as? String
        favoritesCount.text = "\(tweet!.favoritesCount)"
        retweetCount.text = "\(tweet!.retweetCount)"
        let image = (tweet!.user?.profileUrl)! as NSURL
        let date = (tweet!.timestamp)! as NSDate
        let relativeTimestamp = date.dateTimeUntilNow()
        timestampLabel.text = relativeTimestamp
        profileImage.setImageWithURL(image)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retweetButton(sender: AnyObject) {
         print("before: \(tweet!.retweetCount)")
        TwitterClient.sharedInstance.retweet(tweet!.id!, success: { (tweet: Tweet) -> Void in
                print("sucess: \(tweet.retweetCount)")
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
            })
    }

    @IBAction func favoriteButton(sender: AnyObject) {
        print("before: \(tweet!.favoritesCount)")
        TwitterClient.sharedInstance.favorite(tweet!.id!, success: { (tweet: Tweet) -> Void in
            print("sucess: \(tweet.favoritesCount)")
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let userViewController = segue.destinationViewController as! UserViewController
        userViewController.user = tweet?.user
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

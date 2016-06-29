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
        timestampLabel.text = "\(tweet!.timestamp!)"
        
        tweetLabel.sizeToFit()
        let username = tweet!.user?.screenname as? String
        
        screennameLabel.text = "@\(username!)"
        nameLabel.text = tweet?.user?.name as? String
        favoritesCount.text = "\(tweet!.favoritesCount)"
        retweetCount.text = "\(tweet!.retweetCount)"
        let image = (tweet!.user?.profileUrl)! as NSURL
        
        
        profileImage.setImageWithURL(image)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retweetButton(sender: AnyObject) {
    }

    @IBAction func favoriteButton(sender: AnyObject) {
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

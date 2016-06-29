//
//  UserViewController.swift
//  twitter
//
//  Created by Grace Kotick on 6/29/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    var user: User?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let username = user?.screenname as? String
        
        screennameLabel.text = "@\(username!)"
        nameLabel.text = user?.name as? String
        
        let image = (user?.profileUrl)! as NSURL
        let backimage = (user?.backgroundUrl!)! as NSURL
        backgroundImage.setImageWithURL(backimage)
        profileImage.setImageWithURL(image)
        followersCount.text = "\(user!.followers!)"
        followingCount.text = "\(user!.following!)"
        tweetCount.text = "\(user!.statusCount!)"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

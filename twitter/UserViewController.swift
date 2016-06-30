//
//  UserViewController.swift
//  twitter
//
//  Created by Grace Kotick on 6/29/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user: User?
    var tweets: [Tweet]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    var username: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        username = user?.screenname as? String
        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false

        screennameLabel.text = "@\(username!)"
        nameLabel.text = user?.name as? String
        
        let image = (user?.profileUrl)! as NSURL
        let backimage = (user?.backgroundUrl!)! as NSURL
        backgroundImage.setImageWithURL(backimage)
        profileImage.setImageWithURL(image)
        followersCount.text = "\(user!.followers!)"
        followingCount.text = "\(user!.following!)"
        tweetCount.text = "\(user!.statusCount!)"

        self.loadData()
        // Do any additional setup after loading the view.
    }
    func loadData(){
        
        TwitterClient.sharedInstance.userTimeline(username!, success: {(tweets: [Tweet]) -> () in
            self.tweets = tweets
            for tweet in tweets{
                print(tweet.text)
            }
            self.tableView.reloadData()
            }, failure: {(error: NSError) -> () in
                print(error.localizedDescription)
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserTableViewCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.button.tag = indexPath.row
        return cell

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

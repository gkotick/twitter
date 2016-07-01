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
    var liketweets: [Tweet]!

    @IBOutlet weak var likeTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
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
        likeTableView.delegate = self
        likeTableView.dataSource = self
        tableView.hidden = false
        screennameLabel.text = "@\(username!)"
        nameLabel.text = user?.name as? String
        likeTableView.hidden = true
        let image = (user?.profileUrl)! as NSURL
        let backimage = (user?.backgroundUrl!)! as NSURL
        backgroundImage.setImageWithURL(backimage)
        profileImage.setImageWithURL(image)
        followersCount.text = "\(user!.followers!)"
        followingCount.text = "\(user!.following!)"
        tweetCount.text = "\(user!.statusCount!)"

        self.loadData()
        self.loadLikeData()
        // Do any additional setup after loading the view.
    }
    func loadData(){
        
        TwitterClient.sharedInstance.userTimeline(username!, success: {(tweets: [Tweet]) -> () in
            self.tweets = tweets

            self.tableView.reloadData()
            }, failure: {(error: NSError) -> () in
                print(error.localizedDescription)
        })
        
    }
    func loadLikeData(){
        TwitterClient.sharedInstance.currentUserLikes(username!, success: {(tweets: [Tweet]) -> () in
            self.liketweets = tweets
            for tweet in self.liketweets{
                print(tweet.text)
            }
            self.likeTableView.reloadData()

            }, failure: {(error: NSError) -> () in
                print(error.localizedDescription)
        })
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
        
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                tableView.hidden = false
                likeTableView.hidden = true
            case 1:
                tableView.hidden = true
                likeTableView.hidden = false
            default:
                break;
            }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return tweets?.count ?? 0

        } else {
            return liketweets?.count ?? 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == self.tableView{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserTableViewCell
            
            let tweet = self.tweets[indexPath.row]
            cell.tweet = tweet
            cell.button.tag = indexPath.row
            
            let date = (tweet.timestamp)! as NSDate
            let relativeTimestamp = date.dateTimeUntilNow()
            cell.timestampLabel.text = relativeTimestamp
            return cell
        } else {
            let cell = self.likeTableView.dequeueReusableCellWithIdentifier("LikeCell", forIndexPath: indexPath) as! LikeTableViewCell
            
            let tweet = self.liketweets[indexPath.row]
            cell.tweet = tweet
            
            let date = (tweet.timestamp)! as NSDate
            let relativeTimestamp = date.dateTimeUntilNow()
            cell.timestampLabel.text = relativeTimestamp
            return cell

        }
        

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

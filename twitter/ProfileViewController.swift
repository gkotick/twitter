//
//  ProfileViewController.swift
//  twitter
//
//  Created by Grace Kotick on 6/29/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user: User?
    var tweets: [Tweet]!
    var liketweets: [Tweet]!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var likeTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var tweetsCount: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var screennameLabel: UILabel!
    var username: String?{
        didSet{
            screennameLabel.text = "@\(username!)"
            nameLabel.text = user?.name as? String
            likeTableView.delegate = self
            likeTableView.dataSource = self
            likeTableView.hidden = true

            tableView.hidden = false
            let image = (user?.profileUrl)! as NSURL
            let backimage = (user?.backgroundUrl!)! as NSURL
            backgroundImage.setImageWithURL(backimage)
            profileImage.setImageWithURL(image)
            followersCount.text = "\(user!.followers!)"
            followingCount.text = "\(user!.following!)"
            tweetsCount.text = "\(user!.statusCount!)"
            self.loadLikeData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        
        // Do any additional setup after loading the view.
    }
    func loadLikeData(){
        TwitterClient.sharedInstance.currentUserLikes(username!, success: {(tweets: [Tweet]) -> () in
            self.liketweets = tweets
            
            self.likeTableView.reloadData()
            
            }, failure: {(error: NSError) -> () in
                print(error.localizedDescription)
        })
    }
    func loadData(){
        TwitterClient.sharedInstance.currentAccount( {(user: User) -> () in
            self.user = user
            print(user)
            self.username = self.user!.screenname as? String
            TwitterClient.sharedInstance.userTimeline(self.username!, success: {(tweets: [Tweet]) -> () in
                self.tweets = tweets
                
                self.tableView.reloadData()
                }, failure: {(error: NSError) -> () in
                    print(error.localizedDescription)
            })
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
        }    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.tableView{
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileTableViewCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        
        let date = (tweet.timestamp)! as NSDate
        let relativeTimestamp = date.dateTimeUntilNow()
        cell.timestampLabel.text = relativeTimestamp
        return cell
        } else{
            let cell = self.likeTableView.dequeueReusableCellWithIdentifier("ProfileCell2", forIndexPath: indexPath) as! ProfileTableViewCell
            
            let tweet = self.liketweets[indexPath.row]
            cell.tweet = tweet
            
            let date = (tweet.timestamp)! as NSDate
            let relativeTimestamp = date.dateTimeUntilNow()
            cell.timestampLabel.text = relativeTimestamp
            return cell
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ProfileTweetSegue"{
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets[indexPath!.row]
            let detailsViewController = segue.destinationViewController as! DetailsViewController
            detailsViewController.tweet = tweet
        }
        else{
            let cell = sender as! UITableViewCell
            let indexPath = likeTableView.indexPathForCell(cell)
            let tweet = liketweets[indexPath!.row]
            let detailsViewController = segue.destinationViewController as! DetailsViewController
            detailsViewController.tweet = tweet
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

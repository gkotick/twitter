//
//  TweetsViewController.swift
//  twitter
//
//  Created by Grace Kotick on 6/27/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit
import NSDate_TimeAgo

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tweets: [Tweet]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents:UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.loadData()
        // Do any additional setup after loading the view.
    }
    func loadData(){
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            //            for tweet in tweets {
            //                print(tweet.text)
            //            }
            self.tableView.reloadData()
            }, failure: {(error: NSError) -> () in
                print(error.localizedDescription)
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLogOut(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TableViewCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.button.tag = indexPath.row
        
        let date = (tweet.timestamp)! as NSDate
        let relativeTimestamp = date.dateTimeUntilNow()
        cell.timestampLabel.text = relativeTimestamp
        return cell
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        self.loadData()
        
        self.tableView.reloadData()
        
        
        refreshControl.endRefreshing()
        
    }
    override func
        prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "TweetSegue"{
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets[indexPath!.row]
            let detailsViewController = segue.destinationViewController as! DetailsViewController
            detailsViewController.tweet = tweet
            
        } else if segue.identifier == "UserSegue"{
            
            let tweet = tweets[(sender?.tag)!]
            let user = tweet.user
            let userViewController = segue.destinationViewController as! UserViewController
            userViewController.user = user
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

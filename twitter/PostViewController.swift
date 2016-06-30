//
//  PostViewController.swift
//  twitter
//
//  Created by Grace Kotick on 6/29/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    var user: User?
    var tweet: Tweet?
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    func loadData(){
        TwitterClient.sharedInstance.currentAccount({ (user: User) -> () in
            self.user = user
            self.screennameLabel.text =
                user.screenname as? String
            self.nameLabel.text = user.name as? String
            let image = (self.user?.profileUrl)! as NSURL
            self.profileImage.setImageWithURL(image)
            
        }, failure: {(error: NSError) -> () in
                print(error.localizedDescription)
        })
        
        
    }
    @IBAction func postTweet(sender: AnyObject) {
        
        TwitterClient.sharedInstance.tweet(textField.text, success: { (tweet: Tweet) -> Void in
            
            print("sucess")
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })

    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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

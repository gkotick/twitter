//
//  LoginViewController.swift
//  twitter
//
//  Created by Grace Kotick on 6/27/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(sender: AnyObject) {
        
        
        TwitterClient.sharedInstance.login({ () -> () in
            //segue to next view controller
            print("I've loggen in.")
            self.performSegueWithIdentifier("LoginSegue", sender: nil)
        }) { (error: NSError) -> () in
            print("error: \(error.localizedDescription)")
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

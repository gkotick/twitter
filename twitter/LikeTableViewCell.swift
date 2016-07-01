//
//  LikeTableViewCell.swift
//  twitter
//
//  Created by Grace Kotick on 6/30/16.
//  Copyright © 2016 Grace Kotick. All rights reserved.
//

import UIKit

class LikeTableViewCell: UITableViewCell {
    var tweet: Tweet?{
        didSet{
            tweetLabel.text = tweet!.text as? String
            
            tweetLabel.sizeToFit()
            let username = tweet!.user?.screenname as? String
            
            usernameLabel.text = "@\(username!)"
            nameLabel.text = tweet?.user?.name as? String
            favoriteCount.text = "\(tweet!.favoritesCount)"
            retweetCount.text = "\(tweet!.retweetCount)"
            let image = (tweet!.user?.profileUrl)! as NSURL
            
            
            profileImage.setImageWithURL(image)
        }
    }
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

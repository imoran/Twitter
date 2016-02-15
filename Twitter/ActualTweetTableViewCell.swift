//
//  ActualTweetTableViewCell.swift
//  Twitter
//
//  Created by Isis  on 2/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ActualTweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var twitterName: UILabel!
    @IBOutlet weak var actualTweet: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var tweetID: String = ""
    
    var tweet: Tweet! {
        didSet {

            actualTweet.text = tweet.text
            userName.text = tweet.user!.name
            likeLabel.text = "\(tweet.likeCount as! Int)"
            retweetLabel.text = "\(tweet.retweetCount as! Int)"
            timeStamp.text = tweet.createdAtString!

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
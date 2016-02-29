//
//  ActualTweetTableViewCell.swift
//  Twitter
//
//  Created by Isis Moran on 2/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import SwiftMoment

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
//    @IBOutlet weak var tweetPicture: UIImageView!
    
    var didRetweet: Bool = true
    var didLike: Bool = true
    var tweetID: String = ""

    var tweet: Tweet! {
        didSet {
            
            actualTweet.text = tweet.text
            userName.text = tweet.user!.name
            likeLabel.text = "\(tweet.likeCount as! Int)"
            retweetLabel.text = "\(tweet.retweetCount as! Int)"
            timeStamp.text = timeAgo(tweet.createdAt!)
            print(timeAgo(tweet.createdAt))
            print(tweet.createdAt)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePicture.layer.cornerRadius = 3
        profilePicture.clipsToBounds = true
        
//        retweetButton.addTarget(self, action: "switchValueChanged", forControlEvents: UIControlEvents.ValueChanged)

    }
    
    func timeAgo(createdAt: NSDate?) -> String {
        let timeAgoSincePost = (moment() - moment(createdAt!))
        if timeAgoSincePost.hours >= 24 {
            return "\(Int(timeAgoSincePost.days))d"
        } else if timeAgoSincePost.minutes >= 60 {
            return "\(Int(timeAgoSincePost.hours))h"
        } else if timeAgoSincePost.seconds >= 60 {
            return "\(Int(timeAgoSincePost.minutes))m"
        } else {
            return "1m"
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func retweetButtonChange(sender: AnyObject) {
      if didRetweet {
        didRetweet = false
        retweetButton.setImage(UIImage(named: "RetweetOn"), forState: UIControlState.Normal)
    } else {
        didRetweet = true
        retweetButton.setImage(UIImage(named: "Retweet"), forState: UIControlState.Normal)
      }
    }
    
    @IBAction func likeButtonChange(sender: AnyObject) {
        if didLike {
         didLike = false
         likeButton.setImage(UIImage(named: "LikeOn"), forState: UIControlState.Normal)
        } else {
            didLike = true
            likeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
        }
    }
    
    func switchValueChanged() {
        print("Switch Value Changed")
    }
    
  }

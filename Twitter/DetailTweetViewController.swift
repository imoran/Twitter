//
//  DetailTweetViewController.swift
//  Twitter
//
//  Created by Isis  on 2/19/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class DetailTweetViewController: UIViewController {
    
    var detailedTweets: Tweet!
    
    @IBOutlet weak var detailedProfilePicture: UIImageView!
    @IBOutlet weak var detailedUserName: UILabel!
    @IBOutlet weak var detailedScreenName: UILabel!
    @IBOutlet weak var detailedTweet: UILabel!
    @IBOutlet weak var detailedRetweets: UILabel!
    @IBOutlet weak var detailedFavorites: UILabel!
    @IBOutlet weak var detailedTimeStamp: UILabel!
    
    var tweetID: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tweetID = detailedTweets!.id as String
        
        detailedProfilePicture.layer.cornerRadius = 3
        detailedProfilePicture.clipsToBounds = true
        detailedScreenName.text = "@" + detailedTweets!.user!.screenname!
        detailedTweet.text = detailedTweets!.text
        detailedUserName!.text = detailedTweets!.user?.name
        let url = NSURL(string: (detailedTweets!.user?.profileImageUrl!)!)
        detailedProfilePicture.setImageWithURL(url!)
        detailedRetweets.text = "\(detailedTweets.retweetCount as! Int)"
        detailedFavorites.text = "\(detailedTweets.likeCount as! Int)"
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M d y HH:mm:ss"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailstoProfileSegue" {
          let vcdetails = segue.destinationViewController as! ProfileViewController
           vcdetails.profileTweets = detailedTweets
           let user = User.currentUser
           
        
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

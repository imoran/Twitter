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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailedProfilePicture.layer.cornerRadius = 3
        detailedProfilePicture.clipsToBounds = true
        
        detailedScreenName.text = "@" + detailedTweets!.user!.screenname!
        detailedTweet.text = detailedTweets!.text
        detailedUserName!.text = detailedTweets!.user?.name
        let url = NSURL(string: (detailedTweets!.user?.profileImageUrl!)!)
        detailedProfilePicture.setImageWithURL(url!)
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

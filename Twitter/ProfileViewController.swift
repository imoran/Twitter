//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Isis  on 2/28/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var profileTweets: Tweet!
    
    @IBOutlet weak var theProfilePicture: UIImageView!
    @IBOutlet weak var bannerPicture: UIImageView!
    @IBOutlet weak var profileViewName: UILabel!
    @IBOutlet weak var profileViewHandle: UILabel!
    @IBOutlet weak var profileFollowingCount: UILabel!
    @IBOutlet weak var profileFollowerCounttt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileViewName.text = profileTweets!
            .user!.name
        self.profileViewHandle.text = profileTweets!.user!.screenname
        profileFollowerCounttt.text = profileTweets!.user!.followers!
        profileFollowingCount.text = profileTweets!.user!.following!
        
    }
//    
//    func profileInfo() {
//      TwitterClient.sharedInstance.getProfileInfo(["id": profileTweets.id!]) { (tweet, error) -> () in
//    
//      self.profileViewName.text = User.currentUser!.name
//      self.profileViewHandle.text = User.currentUser!.screenname
//      self.theProfilePicture.setImageWithURL(NSURL(string: self.profileTweets!.user!.profileImageUrl!)!)
//        
//       }
//    }

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

//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Isis  on 2/8/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
            
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            })
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActualTweetTableViewCell", forIndexPath: indexPath) as! ActualTweetTableViewCell
        
        cell.profilePicture.setImageWithURL(NSURL(string: tweets![indexPath.row].user!.profileImageUrl!)!)
        cell.userName.text = tweets![indexPath.row].user!.name!
        cell.twitterName.text = "@" + (tweets![indexPath.row].user?.screenname!)!
        cell.actualTweet.text = tweets![indexPath.row].text!
        cell.timeStamp.text = tweets![indexPath.row].createdAtString!
        
        
        return cell
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
            
        }
            return 0
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

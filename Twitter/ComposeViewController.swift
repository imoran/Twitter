//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Isis  on 2/29/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    

    @IBOutlet weak var composeTweet: UITextView!
    
    var comTweet: Tweet?
    var replyID: Int?
    var replying: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        composeTweet.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.tweetContent(composeTweet.text, replyID: replyID, completion: {(success, error) -> () in
            if success != nil {

            }
       })
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

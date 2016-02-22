//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Isis  on 2/8/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftMoment

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var refreshControl: UIRefreshControl!
    let delay = 3.0 * Double(NSEC_PER_SEC)
    var tweets: [Tweet]?
    var loadingMoreView: InfiteScrollActivityView?
    var isMoreDataLoading = false
    var loadMoreOffset = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            })
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func delay(delay:Double, closure:() -> ()) {
        dispatch_after(
            dispatch_time(
              DISPATCH_TIME_NOW,
              Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(1, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            isMoreDataLoading = true
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
            
        }
    }
    
    func loadMoreData() {
        func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
            TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
                self.isMoreDataLoading = true
                
                }, failure: { (operation: NSURLSessionDataTask?,error: NSError!) -> Void in
                    print("error getting home timeline")
                    completion(tweets: nil, error: error)
                    self.isMoreDataLoading = false
                    self.tableView.reloadData()
            })
        }
    }
    
    class InfiteScrollActivityView: UIView {
        var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        static let defaultHeight:CGFloat = 60.0
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupActivityIndicator()
        }
        
        override init(frame aRect: CGRect) {
            super.init(frame: aRect)
            setupActivityIndicator()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        }
        
        func setupActivityIndicator() {
            activityIndicatorView.activityIndicatorViewStyle = .Gray
            activityIndicatorView.hidesWhenStopped = true
            self.addSubview(activityIndicatorView)
        }
        
        func stopAnimating() {
            self.activityIndicatorView.stopAnimating()
            self.hidden = true
        }
        
        func startAnimating() {
            self.hidden = false
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func implementInfiniteScroll() {
//        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
//        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActualTweetTableViewCell", forIndexPath: indexPath) as! ActualTweetTableViewCell
        
        let url = NSURL(string: tweets![indexPath.row].user!.profileImageUrl!);
        cell.profilePicture.setImageWithURL(url!)
        cell.twitterName.text = "@" + (tweets![indexPath.row].user?.screenname!)!
        
        if (tweets != nil) {
            cell.tweet = tweets![indexPath.row]
        }
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if let tweets = self.tweets {
            return tweets.count
        }
            return 0
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        
        var subviewPostion: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        var indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(subviewPostion)!
        let cell =  self.tableView.cellForRowAtIndexPath(indexPath)! as! ActualTweetTableViewCell
        let tweet = tweets![indexPath.row]
        let tweetID = tweet.id
        TwitterClient.sharedInstance.retweetItem(["id": tweetID!]) { (tweet, error) -> () in
            
            if (tweet != nil) {
                self.tweets![indexPath.row].retweetCount = self.tweets![indexPath.row].retweetCount as! Int + 1
                var indexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)

                self.tableView.reloadData()
            }
        }
     }

    @IBAction func onLike(sender: AnyObject) {
  
        var subviewPostion: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        var indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(subviewPostion)!
        let cell =  self.tableView.cellForRowAtIndexPath(indexPath)! as! ActualTweetTableViewCell
        let tweet = tweets![indexPath.row]
        let tweetID = tweet.id
        TwitterClient.sharedInstance.likeItem(["id": tweetID!]) { (tweet, error) -> () in
            if (tweet != nil) {
                self.tweets![indexPath.row].likeCount = self.tweets![indexPath.row].likeCount as! Int + 1
                var indexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
                self.tableView.reloadData()
       }
    }
  }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? ActualTweetTableViewCell {
            let indexPath = self.tableView.indexPathForCell(cell)!.row
            if segue.identifier == "DetailsViewControllerSegue" {
                let vc = segue.destinationViewController as! DetailTweetViewController
                vc.detailedTweets = tweets
            }
        }
    }
}
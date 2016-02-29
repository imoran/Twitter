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
    var tweetsz: Tweet?
    var loadingMoreView: InfiteScrollActivityView?
    var isMoreDataLoading = false
    var loadMoreOffset = 20
    var didRetweet: Bool = true
    var didLike: Bool = true
    
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
    
    override func viewWillAppear(animated: Bool) {
//        navigationItem.rightBarButtonItem = button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiteScrollActivityView.defaultHeight)
        loadingMoreView = InfiteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                loadMoreData()

            }
        }
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
    
    func loadMoreData() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            
            if error != nil {
                self.delay(2.0, closure: {
                    self.loadingMoreView?.stopAnimating()
                })
            } else {
                self.delay(0.5, closure: { Void in
                    self.loadMoreOffset += 20
                    self.tweets!.appendContentsOf(tweets!)
                    self.tableView.reloadData()
                    self.loadingMoreView?.stopAnimating()
                    self.isMoreDataLoading = false
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActualTweetTableViewCell", forIndexPath: indexPath) as! ActualTweetTableViewCell
        
        let url = NSURL(string: tweets![indexPath.row].user!.profileImageUrl!)
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
    
        let subviewPostion: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(subviewPostion)!
        let cell =  self.tableView.cellForRowAtIndexPath(indexPath)! as!  ActualTweetTableViewCell
        let tweet = tweets![indexPath.row]
        let tweetID = tweet.id
        
        TwitterClient.sharedInstance.retweetItem(["id": tweetID!]) { (tweet, error) -> () in
            
            if self.didRetweet {
                self.didRetweet = true
                self.tweets![indexPath.row].retweetCount = self.tweets![indexPath.row].retweetCount as! Int + 1
                var indexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)

                self.tableView.reloadData()
                
            } else {
                self.didRetweet = false
                self.tweets![indexPath.row].retweetCount = self.tweets![indexPath.row].retweetCount as! Int - 1
                self.tableView.reloadData()
            }
        }
    }
    
//            if (tweet != nil) {
//                
//                if self.didRetweet {
//                 self.didRetweet = true
//                 self.tweets![indexPath.row].retweetCount = self.tweets![indexPath.row].retweetCount as! Int + 1
//                 var indexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
//                    self.tableView.reloadData()
//
//                } else {
//                    self.didRetweet = false
//                    self.tweets![indexPath.row].retweetCount = self.tweets![indexPath.row].retweetCount as! Int - 1
//                    self.tableView.reloadData()
//
//                }
            
    @IBAction func onLike(sender: AnyObject) {
        let subviewPostion: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(subviewPostion)!
        let cell =  self.tableView.cellForRowAtIndexPath(indexPath)! as! ActualTweetTableViewCell
        let tweet = tweets![indexPath.row]
        let tweetID = tweet.id
        TwitterClient.sharedInstance.likeItem(["id": tweetID!]) { (tweet, error) -> () in
            if (tweet != nil) {
                self.tweets![indexPath.row].likeCount = self.tweets![indexPath.row].likeCount as! Int + 1
                let indexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
                
                self.tableView.reloadData()
       }
    }
  }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "detailsSegue" {
                let indexPath = tableView.indexPathForCell(sender as! ActualTweetTableViewCell)
                let tweetsz = tweets![indexPath!.row]
                let vc = segue.destinationViewController as! DetailTweetViewController
                vc.detailedTweets = tweetsz
                let user = User.currentUser


            }
        }
    }

//
//  User.swift
//  Twitter
//
//  Created by Isis  on 2/8/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "CurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"


class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    var profileBannerURL: NSURL?
    var followers: Int
    var following: Int
    
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        followers = dictionary["followers_count"] as! Int
        following = dictionary["friends_count"] as! Int
        
        let banner = dictionary["profile_background_image_url_https"] as? String
        if banner != nil {
            profileBannerURL = NSURL(string: banner!)!
        }
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        
    }
    
    class var currentUser: User? {
        get {
          if _currentUser == nil {
          let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
           if data != nil {
            do {
              let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
               _currentUser = User(dictionary: dictionary as! NSDictionary)
            } catch _ {
            }
          }
        }
        return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions())
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch _ {
                    
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}


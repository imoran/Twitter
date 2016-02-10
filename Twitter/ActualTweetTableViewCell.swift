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

    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

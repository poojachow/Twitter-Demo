//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Pooja Chowdhary on 4/14/17.
//  Copyright © 2017 Pooja Chowdhary. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var retweetedCountLabel: UILabel!
    @IBOutlet weak var favouritesCountLabel: UILabel!
    @IBAction func onReplyButton(_ sender: UIButton) {
        
    }
    
    @IBAction func onFavouriteButton(_ sender: UIButton) {
        let dictionary = ["id" : tweet.id!]
        if tweet.favourited == true {
            TwitterClient.sharedInstance?.destroyFavourite(dictionary: dictionary as NSDictionary, success: { (isSuccess: Bool) in
                self.tweet.favourited = false
                self.updateFavouritesLabel()
            })
        }
        else {
            TwitterClient.sharedInstance?.createFavourite(dictionary: dictionary as NSDictionary, success: { (isSuccess: Bool) in
                self.tweet.favourited = true
                self.updateFavouritesLabel()
            })
        }
    }
    @IBAction func onRetweetButton(_ sender: UIButton) {
        if tweet.retweeted == true {
            TwitterClient.sharedInstance?.destroyRetweet(id: tweet.id!, success: { (isSuccess: Bool) in
                self.tweet.retweeted = false
                self.updateRetweetsLabel()
            })
        }
        else {
            TwitterClient.sharedInstance?.createRetweet(id: tweet.id!, success: { (isSuccess: Bool) in
                self.tweet.retweeted = true
                self.updateRetweetsLabel()
            })
        }
    }
    @IBOutlet weak var onRetweetButtonLabel: UIButton!
    @IBOutlet weak var onFavouriteButtonLabel: UIButton!
    
    var tweet: Tweet! {
        didSet{
            nameLabel.text = tweet.user?.name
            tweetTextLabel.text = tweet.text
            if (tweet.user?.screenname) != nil {
                screenNameLabel.text = "@\((tweet.user?.screenname)!)"
            }
        
            if tweet.timestamp != nil {
                
                let currentDate = Date()
                let interval = currentDate.timeIntervalSince(tweet.timestamp!)
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.day, .hour, .minute, .second]
                formatter.unitsStyle = .abbreviated
                formatter.maximumUnitCount = 1
                timeStampLabel.text = formatter.string(from: interval)
            }
            else {
                timeStampLabel.text = ""
            }

            if let profileUrlString = tweet.user?.profileurl {
                profileImageView.setImageWith(profileUrlString)
            }
            
            // set Favourites
            updateFavouritesButton()
            favouritesCountLabel.text = String(tweet.favouritesCount)
            
            // set Retweets
            updateRetweetsButton()
            retweetedCountLabel.text = String(tweet.retweetCount)
        }
    }
    
    func updateRetweetsLabel() {
        if tweet.retweeted == true {
            tweet.retweetCount = tweet.retweetCount + 1
        }
        else {
            tweet.retweetCount = tweet.retweetCount - 1
        }
        retweetedCountLabel.text = String(tweet.retweetCount)
        updateRetweetsButton()
    }
    
    func updateRetweetsButton() {
        if tweet.retweeted == true {
            let image = UIImage(named: "greenRetweet")
            onRetweetButtonLabel.setImage(image, for: .normal)
        }
        else {
            let image = UIImage(named: "greyRetweet")
            onRetweetButtonLabel.setImage(image, for: .normal)
        }
    }
    
    func updateFavouritesButton() {
        if tweet.favourited == true {
            let image = UIImage(named: "redLike")
            onFavouriteButtonLabel.setImage(image, for: .normal)
        }
        else {
            let image = UIImage(named: "greyLike")
            onFavouriteButtonLabel.setImage(image, for: .normal)
        }
    }
    
    func updateFavouritesLabel() {
        if tweet.favourited == true {
            tweet.favouritesCount = tweet.favouritesCount + 1
        }
        else {
            tweet.favouritesCount = tweet.favouritesCount - 1
        }
        favouritesCountLabel.text = String(tweet.favouritesCount)
        updateFavouritesButton()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

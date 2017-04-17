//
//  TweetDetailViewController.swift
//  TwitterDemo
//
//  Created by Pooja Chowdhary on 4/15/17.
//  Copyright © 2017 Pooja Chowdhary. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, ReplyViewControllerDelegate {
    @objc internal func sendTweet(sentTweet: Tweet) {
        // tweet returned
    }
    
    var tweet: Tweet!
    var isfavourite: Bool!
    var isRetweeted: Bool!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBAction func onFavouriteButton(_ sender: UIButton) {
        let dictionary = ["id" : tweet.id!]
        if tweet.favourited == true {
            TwitterClient.sharedInstance?.destroyFavourite(dictionary: dictionary as NSDictionary as NSDictionary, success: { (status: Bool) in
                self.tweet.favourited = false
                self.updateFavouritesLabel()
            })
        }
        else {
            TwitterClient.sharedInstance?.createFavourite(dictionary: dictionary as NSDictionary, success: { (status: Bool) in
                self.tweet.favourited = true
                self.updateFavouritesLabel()
            })
        }
    }

    @IBAction func onRetweetButton(_ sender: Any) {
        if isRetweeted == true {
            // unretweet
            TwitterClient.sharedInstance?.destroyRetweet(id: tweet.id!, success: { (isSuccess: Bool) in
                self.isRetweeted = false
                self.updateRetweetLabel()
            })
        }
        else {
            // retweet
            TwitterClient.sharedInstance?.createRetweet(id: tweet.id!, success: { (isSuccess: Bool) in
                self.isRetweeted = true
                self.updateRetweetLabel()
            })
        }
    }
    
    @IBAction func onReplyButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Tweet"
        if let tweet = tweet {
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = "@\((tweet.user?.screenname)!)"
            tweetText.text = tweet.text
            retweetLabel.text = String(tweet.retweetCount)
            favoritesLabel.text = String(tweet.favouritesCount)
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true
            isfavourite = tweet.favourited
            isRetweeted = tweet.retweeted
            
            if let profileUrlString = tweet.user?.profileurl {
                profileImageView.setImageWith(profileUrlString)
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d/M/yyyy, h:m a"
            timeStampLabel.text = formatter.string(from: tweet.timestamp!)
            changeFavouriteButton()
            changeRetweetButton()
            
        }
    }
    
    func changeFavouriteButton() {
        if tweet.favourited == true {
            let image = UIImage(named: "redLike")
            favouriteButton.setImage(image, for: .normal)
        }
        else {
            let image = UIImage(named: "greyLike")
            favouriteButton.setImage(image, for: .normal)
        }
    }
    
    func changeRetweetButton() {
        if tweet.retweeted == true {
            let image = UIImage(named: "greenRetweet")
            retweetButton.setImage(image, for: .normal)
        }
        else {
            let image = UIImage(named: "greyRetweet")
            retweetButton.setImage(image, for: .normal)
        }
    }
    
    func updateRetweetLabel() {
        tweet.retweeted = isRetweeted
        if isRetweeted == true {
            tweet.retweetCount = tweet.retweetCount + 1
        }
        else {
            tweet.retweetCount = tweet.retweetCount - 1
        }
        retweetLabel.text = String(tweet.retweetCount)
        changeRetweetButton()
    }
    
    func updateFavouritesLabel() {
        if tweet.favourited == true {
            tweet.favouritesCount = tweet.favouritesCount + 1
        }
        else {
            tweet.favouritesCount = tweet.favouritesCount - 1
        }
        favoritesLabel.text = String(tweet.favouritesCount)
        changeFavouriteButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReplyFromDetail" {
            print("replying")
            let navigationcontroller = segue.destination as! UINavigationController
            let replyController = navigationcontroller.topViewController as! ReplyViewController
            replyController.tweet = tweet
            replyController.delegate = self
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

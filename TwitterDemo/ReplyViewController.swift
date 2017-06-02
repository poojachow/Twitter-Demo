//
//  ReplyViewController.swift
//  TwitterDemo
//
//  Created by Pooja Chowdhary on 4/16/17.
//  Copyright © 2017 Pooja Chowdhary. All rights reserved.
//

import UIKit

@objc protocol ReplyViewControllerDelegate {
    @objc optional func sendTweet(sentTweet: Tweet)
}

class ReplyViewController: UIViewController, UITextViewDelegate {
    
    var tweet: Tweet!
    var tweetText = String()
    var tweetCharacterCount = 140
    var delegate: ReplyViewControllerDelegate!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var replyButtonLabel: UIBarButtonItem!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var characterCountBarButtonLabel: UIBarButtonItem!
    @IBOutlet weak var bottomScreenConstraint: NSLayoutConstraint!
    
    @IBAction func onCancelButton(_ sender: UIBarButtonItem) {
        navigateFromThisViewController()
    }
    @IBAction func onReplyButton(_ sender: UIBarButtonItem) {
        var newTweetId = ""
        if tweet != nil {
            TwitterClient.sharedInstance?.replyTweet(message: tweetText, id: self.tweet.id!, success: { (newId: String) in
                newTweetId = newId
            })
            let tweet = Tweet(tweetText: tweetText, newId: newTweetId)
            delegate?.sendTweet!(sentTweet: tweet)
            navigateFromThisViewController()
        }
        else {
            print("Tweet was not passed to ReplyViewController")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = tweet.user?.name
        screenLabel.text = "@\((tweet.user?.screenname)!)"
        tweetTextLabel.text = tweet.text
        tweetTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        tweetTextView.becomeFirstResponder()
    }

    func navigateFromThisViewController() {
        tweetTextView.resignFirstResponder()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func keyBoardWillShow(notification: Notification) {
        
        // Gives keyboard size needed to resize tweetTextView
        let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect = value.cgRectValue
        self.bottomScreenConstraint.constant = rect.size.height
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = 140 - tweetTextView.text.characters.count
        characterCountBarButtonLabel.title = String(count)
        if count >= 0 {
            
            //   change font color, count color, enable tweet button
            tweetText = tweetTextView.text
            characterCountBarButtonLabel.tintColor = UIColor.lightGray
            replyButtonLabel.isEnabled = true
            
            // @name
            
        }
        else {
            //   change font color, count color, disable tweet button
            characterCountBarButtonLabel.tintColor = UIColor.red
            replyButtonLabel.isEnabled = false
            
        }
    }

}

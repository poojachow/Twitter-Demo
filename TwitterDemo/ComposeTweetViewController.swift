//
//  ComposeTweetViewController.swift
//  TwitterDemo
//
//  Created by Pooja Chowdhary on 4/14/17.
//  Copyright © 2017 Pooja Chowdhary. All rights reserved.
//

import UIKit

@objc protocol ComposeTweetViewControllerDelegate {
    @objc optional func sendTweet(sentTweet: Tweet)
}

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var characterCountBarButton: UIBarButtonItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bottomScreenConstraint: NSLayoutConstraint!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    var delegate: ComposeTweetViewControllerDelegate!
    var tweetText = String()
    var tweetCharacterCount = 140
    
    @IBAction func onCancelButton(_ sender: UIBarButtonItem) {
        navigateFromThisViewController()
    }
    
    @IBAction func onSaveButton(_ sender: UIBarButtonItem) {
        let dictionary = ["status": tweetText]
        var newTweetId = 0
        TwitterClient.sharedInstance?.composeNewTweet(dictionary: dictionary as NSDictionary, success: { (newId: Int) in
            newTweetId = newId
        })
        let tweet = Tweet(tweetText: tweetText, newId: newTweetId)
        delegate?.sendTweet!(sentTweet: tweet)
        navigateFromThisViewController()
    }
    
    func navigateFromThisViewController() {
        tweetTextView.resignFirstResponder()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetTextView.delegate = self
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        if let profileUrlString = User.currentUser?.profileurl {
            profileImageView.setImageWith(profileUrlString)
        }
        nameLabel.text = User.currentUser?.name
        screenNameLabel.text = User.currentUser?.screenname
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        tweetTextView.becomeFirstResponder()
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
        print(textView.text)
        print(textView.text.characters.count)
        let count = 140 - textView.text.characters.count
        characterCountBarButton.title = String(count)
        if count >= 0 {

         //   change font color, count color, enable tweet button
            tweetText = tweetTextView.text
            characterCountBarButton.tintColor = UIColor.lightGray
            saveBarButton.isEnabled = true
        }
        else {
            //   change font color, count color, disable tweet button
            characterCountBarButton.tintColor = UIColor.red
            saveBarButton.isEnabled = false
            
//            if let attributedString = textView.attributedText {
//                
//                // make mutable attributed string
//                let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
//                
//                let tempText = textView.text as NSString
//                
//                let tempRange = NSMakeRange(140, tempText.length)
//                let attributes = [NSForegroundColorAttributeName: UIColor.red]
//                
//                
//           //     mutableAttributedString.addAttributes(attributes, range: tempRange)
//        //        textView.attributedText = mutableAttributedString
//                
//            }
//            
//            
//            
            
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

//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Pooja Chowdhary on 4/13/17.
//  Copyright © 2017 Pooja Chowdhary. All rights reserved.
//
//  Replace "XXXX" with valid Consumer Key and Consumer Secret

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "XXXX", consumerSecret: "XXXX")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
         //clear keychains of previous session
        TwitterClient.sharedInstance?.deauthorize()
        
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            
            let token = (requestToken?.token)!
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
            UIApplication.shared.open(url)
            
        }, failure: { (error: Error?) in
            print("Error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.usedDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in

            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
        
        }) { (error: Error?) in
            print("Error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: (NSError) -> ()) {
//        var dictionary: NSDictionary!
//        if maxid == nil {
//            dictionary = ["count": 20]
//        }
//        else {
//            dictionary = ["count": 20, "max_id": maxid!]
//        }
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error)")
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func composeNewTweet(dictionary: NSDictionary, success: @escaping (String) -> ()) {
        post("1.1/statuses/update.json", parameters: dictionary, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
       //     let newId = userDictionary["id"] as? Int
            let newId = userDictionary["id_str"] as? String
            print(userDictionary)
            print("newID is \(newId)")
            success(newId!)

        //    success(userDictionary)
        }) { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
        }
    }
    
  func createFavourite(dictionary: NSDictionary, success: @escaping (Bool) -> ()) {
        post("1.1/favorites/create.json", parameters: dictionary, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            success(true)
        }) { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error)")
        }
    }
    
    func destroyFavourite(dictionary: NSDictionary, success: @escaping (Bool) -> ()) {
        post("1.1/favorites/destroy.json", parameters: dictionary, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            success(true)
        }) { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error)")
        }
    }
    
    func destroyRetweet(id: String, success: @escaping (Bool) -> ()) {
        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in

            success(true)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error)")
        }
    }

    func createRetweet(id: String, success: @escaping (Bool) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in

            success(true)
        }) { (task: URLSessionDataTask?, error: Error) in
             print("Error: \(error)")
        }
    }
    
    func replyTweet(message: String, id: String, success: @escaping (String) -> ()) {
        let dictionary = ["status": message, "in_reply_to_status_id": id] as NSDictionary
        post("1.1/statuses/update.json", parameters: dictionary, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let newId = userDictionary["id"] as? String
            success(newId!)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error)")
        }
    }
}

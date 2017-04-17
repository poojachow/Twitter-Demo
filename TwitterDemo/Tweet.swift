//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Pooja Chowdhary on 4/13/17.
//  Copyright © 2017 Pooja Chowdhary. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    //static var maxIdTweet = 0

    var text: String?
    var timestamp: Date?
    var retweetCount: Int
    var favouritesCount: Int
    var user: User?
    var favourited: Bool?
    var id: Int?
    var retweeted: Bool?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favouritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        let userDictionary = dictionary["user"] as! NSDictionary
        user = User(dictionary: userDictionary)
        
        if dictionary["created_at"] != nil {
            let timestampString = dictionary["created_at"] as! String
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        favourited = dictionary["favorited"] as? Bool
        id = (dictionary["id"] as? Int) ?? 0
        retweeted = dictionary["retweeted"] as? Bool
        print(dictionary)
        
    }
    
    init(tweetText: String, newId: Int) {
        text = tweetText
        user = User.currentUser
        retweetCount = 0
        favouritesCount = 0
        id = newId
        favourited = false
        retweeted = false
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
//            if maxIdTweet == 0 {
//                maxIdTweet = tweet.id!
//            }
//            else if maxIdTweet < tweet.id! {
//                maxIdTweet = tweet.id!
//            }
            tweets.append(tweet)
        }
        return tweets
    }
    
    func markFavourite(isFavourite: Bool) {
        favourited = isFavourite
    }
    
}

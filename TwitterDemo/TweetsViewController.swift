//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Pooja Chowdhary on 4/13/17.
//  Copyright © 2017 Pooja Chowdhary. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ComposeTweetViewControllerDelegate, ReplyViewControllerDelegate, UIScrollViewDelegate {
    @objc internal func sendTweet(sentTweet: Tweet) {
     //   print("Yayyyy \(sentTweet.text)")
    }

    var isMoreDataLoading = false
    var tweets: [Tweet]!

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        updateTimeline()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
     func refreshControlAction(_ refreshControl: UIRefreshControl) {
        updateTimeline()
        refreshControl.endRefreshing()
    }
  
    func updateTimeline() {
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: NSError) in
            print("Error: \(error)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweetsCount = tweets?.count {
            return tweetsCount
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Code to load more results
                updateTimeline()
                tableView.reloadData()
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ComposeTweet" {
            let navigationVC = segue.destination as! UINavigationController
            let modalVC = navigationVC.topViewController as! ComposeTweetViewController
            modalVC.delegate = self
        }
        if segue.identifier == "TweetDetail" {
            let cell = sender as! TweetCell
            let indexpath = tableView.indexPath(for: cell)
            let destinationVC = segue.destination as! TweetDetailViewController
            destinationVC.tweet = tweets[(indexpath?.row)!]
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

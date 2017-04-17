//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by Pooja Chowdhary on 4/13/17.
//  Copyright © 2017 Pooja Chowdhary. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    var dictionary = Dictionary<String, String>()
    
    @IBAction func onLoginButton(_ sender: UIButton) {
        
        TwitterClient.sharedInstance?.login(success: {
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
        }, failure: { (error: Error) in
            print("Error: \(error.localizedDescription)")
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

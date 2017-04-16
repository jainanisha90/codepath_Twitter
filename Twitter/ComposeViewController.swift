//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Anisha Jain on 4/15/17.
//  Copyright © 2017 Anisha Jain. All rights reserved.
//

import UIKit
import MBProgressHUD

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var currentUserImageView: UIImageView!
    @IBOutlet weak var currentUserNameLabel: UILabel!
    @IBOutlet weak var currentUserScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.delegate = self
        tweetTextView.text = "Type your tweet here..."
        tweetTextView.textColor = .lightGray
        //tweetTextView.becomeFirstResponder()
        
        let currentUser = User.currentUser
        currentUserImageView.setImageWith((currentUser?.profileImageUrl)!)
        currentUserNameLabel.text = currentUser?.name
        currentUserScreenNameLabel.text = currentUser?.screenName
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTweetButton(_ sender: Any) {
        
        if let tweetMessage = tweetTextView.text {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            TwitterClient.sharedInstance.newTweet(tweetMessage: tweetMessage, success: {
                print("tweeted: ")
                MBProgressHUD.hide(for: self.view, animated: true)
                
                NotificationCenter.default.post(name: reloadHomeTimeline, object: nil)
                
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error during posting a tweet", error)
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }
   
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ tweetTextView: UITextView) {
        if tweetTextView.textColor == .lightGray {
            tweetTextView.text = ""
            tweetTextView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ tweetTextView: UITextView) {
        if tweetTextView.text == "" {
            tweetTextView.text = "Type your tweet here..."
            tweetTextView.textColor = .lightGray
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

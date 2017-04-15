//
//  TwitterClient.swift
//  Twitter
//
//  Created by Anisha Jain on 4/14/17.
//  Copyright © 2017 Anisha Jain. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "2wBWxpkRFY6io5dZTY0uT7y61"
let twitterConsumerSecret = "6NdyWeWsDOMCpwHsntMTraTIWX6iSjYFF6J1yuTo4UNHxhQOvk"
let twitterBaseURL = URL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance!
    }
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        // Fetch request token and redirect to authorization page
        requestSerializer.removeAccessToken()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL:
            URL(string: "twitterdemotrial://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("Got request token")
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")
                UIApplication.shared.open(authURL!)
        }) { (error: Error!) -> Void in
            print("failed to get request token")
            self.loginFailure?(error)
        }
        print("escaping")
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: Notifications.userDidLogoutNotification.name, object: nil)
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        self.get("1.1/account/verify_credentials.json", parameters: nil, success:
            { (operation: URLSessionDataTask!, response: Any!) -> Void in
                // print("user:", response)
                let user = User(dictionary: response as! NSDictionary)
                success(user)
                User.currentUser = user
                print("user: ", user.name!)
                self.loginSuccess?()
        }, failure: { (operation: URLSessionDataTask!, error: Error!) -> Void in
            failure(error)
            print("Error getting current user")
        })
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: @escaping (_ tweets: [Tweet]?, _ error: Error?) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: params,
            success: { (operation: URLSessionDataTask!, response: Any!) -> Void in
                // print("home timeline:", response)
                let tweets = Tweet.tweetsWithArray(array: response as! [NSDictionary])
                completion(tweets, nil)
                for tweet in tweets {
                    print("text: \(tweet.text!) created at \(tweet.createdAt!)")
                }
        }, failure: { (operation: URLSessionDataTask!, error: Error!) -> Void in
            print("Error getting home timeline")
            completion(nil, error)
        })
    }
    
    func handleOpenURL(url: URL) {
        fetchAccessToken(withPath: "oauth/access_token",
                         method: "POST",
                         requestToken: BDBOAuth1Credential(queryString: url.query),
                         success: { (access_token: BDBOAuth1Credential!) -> Void in
                            print("got access token")
                            self.requestSerializer.saveAccessToken(access_token)
                            self.currentAccount(success: { (user: User) in
                                User.currentUser = user
                                self.loginSuccess?()
                            }, failure: { (error: Error) in
                                self.loginFailure?(error)
                            })
        }) { (error: Error!) -> Void in
            print("failed to get access token")
            self.loginFailure?(error)
        }
    }

}

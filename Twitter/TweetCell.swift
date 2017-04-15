//
//  TweetCell.swift
//  Twitter
//
//  Created by Anisha Jain on 4/15/17.
//  Copyright © 2017 Anisha Jain. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    var tweet : Tweet! {
        didSet {
            userNameLabel.text  = tweet.user?.name
            profileImageView.setImageWith((tweet.user?.profileImageUrl)!)
            screenNameLabel.text = "@\(tweet!.user!.screenName!)"
            postTextLabel.text = tweet.text
            createdAtLabel.text = "\(tweet.createdAt!)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

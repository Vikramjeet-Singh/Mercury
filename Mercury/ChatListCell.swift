//
//  ChatListCell.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 8/6/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    @IBOutlet private weak var userPhoto: RoundedImageView!
    @IBOutlet private weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(user: User?) {
        username.text = "Jamie Lannister"
    }
}

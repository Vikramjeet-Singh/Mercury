//
//  ProfileHeaderCell.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 8/6/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UITableViewCell {

    @IBOutlet private weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(title: String) {
        self.title.text = title
    }

}

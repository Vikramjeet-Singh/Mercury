//
//  ProfileActionCell.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 8/6/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import UIKit

class ProfileActionCell: UITableViewCell {
    
    enum ActionType: Int {
        case logout = 0
        case deactivate = 1
        
        var title: String {
            switch self {
            case .logout: return "Logout"
            case .deactivate: return "Deactivate Account"
            }
        }
        
        init(at row: Int) {
            self.init(rawValue: row)!
        }
    }
    
    @IBOutlet private weak var actionButton: UIButton!
    
    private var actionType: ActionType = .logout

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(type: ActionType) {
        actionType = type
        actionButton.setTitle(actionType.title, for: .normal)
    }

    @IBAction func handleAction(_ sender: UIButton) {
        switch actionType {
        case .logout:
            logout()
        case .deactivate:
            deactivate()
        }
    }
    
    private func logout() {

    }
    
    private func deactivate() {
        
    }
    
}

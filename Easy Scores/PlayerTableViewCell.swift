//
//  PlayerTableViewCell.swift
//  Easy Scores
//
//  Created by Ian Fisher on 10/24/14.
//  Copyright (c) 2014 iFisher. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    func configureForPlayer(player: Player) {
        self.nameTextField.text = player.name
    }
    
    // MARK: Subviews
    
    lazy var nameTextField: UITextField = {
        var tag: Int = 1
        return self.contentView.viewWithTag(tag) as UITextField
    }()
   
}

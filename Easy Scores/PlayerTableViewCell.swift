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
        self.nameLabel.text = player.name
        self.scoreLabel.text = player.score.stringValue
    }
    
    // MARK: Subviews
    
    lazy var nameLabel: UILabel = {
        return self.contentView.viewWithTag(1) as UILabel
    }()
   
    lazy var stepper: UIStepper = {
        return self.contentView.viewWithTag(2) as UIStepper
    }()
    
    lazy var scoreLabel: UILabel = {
        return self.contentView.viewWithTag(3) as UILabel
    }()
}

//
//  PlayerTableViewCell.swift
//  Easy Scores
//
//  Created by Ian Fisher on 10/24/14.
//  Copyright (c) 2014 iFisher. All rights reserved.
//

import UIKit
import CoreData

class PlayerTableViewCell: UITableViewCell {

    var playerId: NSManagedObjectID?
    var delegate: PlayerScoreDelegate?
    
    func configureForPlayer(player: Player) {
        self.playerId = player.objectID
        self.nameLabel.text = player.name
        self.scoreLabel.text = player.score.stringValue
    }
    
    @IBAction func updateScoreFromStepper(sender: AnyObject) {
        let score = self.stepper.value
        self.delegate?.scoreDidUpdate(playerId: self.playerId!, score: score)
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


protocol PlayerScoreDelegate {
    func scoreDidUpdate(#playerId: NSManagedObjectID, score: Double)
}

//
//  SettingsView.swift
//  Easy Scores
//
//  Created by Ian Fisher on 12/4/14.
//  Copyright (c) 2014 iFisher. All rights reserved.
//

import Foundation
import UIKit

class SettingsView: UIView {
    
    var startingScoreView: SettingsItemView!
    var minimumScoreView: SettingsItemView!
    var maximumScoreView: SettingsItemView!
    
    var constraintsSet = false
    
    override init() {
        super.init(frame: CGRect.zeroRect)
        
        let startingScoreView = SettingsItemView.loadFromNib()
        startingScoreView.titleLabel.text = "Starting Score"
        startingScoreView.subtitleLabel.text = "Blank for starting score of 0"
        
        let minimumScoreView = SettingsItemView.loadFromNib()
        minimumScoreView.titleLabel.text = "Minimum Score"
        minimumScoreView.subtitleLabel.text = "Blank for no minimum score"
        
        let maximumScoreView = SettingsItemView.loadFromNib()
        maximumScoreView.titleLabel.text = "Maximum Score"
        maximumScoreView.subtitleLabel.text = "Blank for no maxnimum score"
        
        self.addSubview(startingScoreView)
        self.addSubview(minimumScoreView)
        self.addSubview(maximumScoreView)
        
        self.startingScoreView = startingScoreView
        self.minimumScoreView = minimumScoreView
        self.maximumScoreView = maximumScoreView
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if !constraintsSet {
            constraintsSet = true
            
            self.startingScoreView.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.minimumScoreView.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.maximumScoreView.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            let views = [
                "startingScore": self.startingScoreView,
                "minimumScore": self.minimumScoreView,
                "maximumScore": self.maximumScoreView,
            ]

            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[startingScore]-8-[minimumScore]-[maximumScore]", options: nil, metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[startingScore]-8-|", options: nil, metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[minimumScore]-8-|", options: nil, metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[maximumScore]-8-|", options: nil, metrics: nil, views: views))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let views = [
            "startingScore": self.startingScoreView,
            "minimumScore": self.minimumScoreView,
            "maximumScore": self.maximumScoreView,
        ]
    }
}
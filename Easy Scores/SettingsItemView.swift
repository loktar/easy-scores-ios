//
//  SettingsItemView.swift
//  Easy Scores
//
//  Created by Ian Fisher on 12/4/14.
//  Copyright (c) 2014 iFisher. All rights reserved.
//

import Foundation
import UIKit

class SettingsItemView: UIView {
    
    class func loadFromNib() -> SettingsItemView {
        return NSBundle.mainBundle().loadNibNamed("SettingsItemView", owner: nil, options: nil)[0] as SettingsItemView
    }
    
    lazy var titleLabel: UILabel = {
        self.viewWithTag(1) as UILabel
    }()
    
    lazy var subtitleLabel: UILabel = {
        self.viewWithTag(2) as UILabel
    }()
    
    lazy var errorLabel: UILabel = {
        self.viewWithTag(3) as UILabel
    }()
    
    lazy var textField: UITextField = {
        self.viewWithTag(4) as UITextField
    }()
}
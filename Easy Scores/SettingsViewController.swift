//
//  SettingsViewController.swift
//  Easy Scores
//
//  Created by Ian Fisher on 11/25/14.
//  Copyright (c) 2014 iFisher. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SettingsViewController : UIViewController {
    
    @IBOutlet var startingScoreTextField: UITextField!
    @IBOutlet var minimumScoreTextField: UITextField!
    @IBOutlet var maximumScoreTextField: UITextField!
    
    let coreDataHelper = CoreDataHelper.sharedInstance()
    var settings: Settings!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let settingsView = SettingsView()
        settingsView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(settingsView)
        
        let views = [
            "topGuide": self.topLayoutGuide,
            "settingsView": settingsView,
        ]

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide][settingsView]|", options: nil, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[settingsView]|", options: nil, metrics: nil, views: views))
        
        settings = Settings.currentSettings(self.coreDataHelper.managedObjectContext!)
        
//        self.startingScoreTextField.text = settings.startingScore?.stringValue ?? ""
//        self.minimumScoreTextField.text = settings.minimumScore?.stringValue ?? ""
//        self.maximumScoreTextField.text = settings.maximumScore?.stringValue ?? ""
    }
    
    // TODO only save if passes validation
    // TODO show validation errors inline
    
    @IBAction func updateStartingScoreFromView(textField: UITextField) {
        settings.startingScore = textField.text.toInt() ?? 0
        self.coreDataHelper.managedObjectContext?.save(nil)
    }
    
    @IBAction func updateMinScoreFromView(textField: UITextField) {
        settings.minimumScore = textField.text.toInt()
        self.coreDataHelper.managedObjectContext?.save(nil)
    }

    @IBAction func updateMaxScoreFromView(textField: UITextField) {
        settings.maximumScore = textField.text.toInt()
        self.coreDataHelper.managedObjectContext?.save(nil)
    }

}
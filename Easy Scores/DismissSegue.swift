//
//  DismissSegue.swift
//  Easy Scores
//
//  Created by Ian Fisher on 11/25/14.
//  Copyright (c) 2014 iFisher. All rights reserved.
//

import Foundation
import UIKit

class DismissSegue : UIStoryboardSegue {
    override func perform() {
        let vc = self.sourceViewController as UIViewController
        vc.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
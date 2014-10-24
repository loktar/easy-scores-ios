//
//  Player.swift
//  Easy Scores
//
//  Created by Ian Fisher on 10/24/14.
//  Copyright (c) 2014 iFisher. All rights reserved.
//

import Foundation
import CoreData

class Player: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var score: NSNumber

}

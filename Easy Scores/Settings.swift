//
//  Settings.swift
//  Easy Scores
//
//  Created by Ian Fisher on 11/26/14.
//  Copyright (c) 2014 iFisher. All rights reserved.
//

import Foundation
import CoreData

class Settings: NSManagedObject {
    
    @NSManaged var startingScore: NSNumber?
    @NSManaged var minimumScore: NSNumber?
    @NSManaged var maximumScore: NSNumber?
    
    class func currentSettings(managedObjectContext: NSManagedObjectContext) -> Settings {
        let request = NSFetchRequest(entityName: "Settings")
        request.fetchLimit = 1
        
        let results = managedObjectContext.executeFetchRequest(request, error: nil)
        return results?.count > 0 ? results!.first as Settings : createSettings(managedObjectContext)
    }

    class func createSettings(managedObjectContext: NSManagedObjectContext) -> Settings {
        let settings = NSEntityDescription.insertNewObjectForEntityForName("Settings", inManagedObjectContext: managedObjectContext) as Settings
        settings.startingScore = 0
        managedObjectContext.save(nil)

        return settings
    }
}
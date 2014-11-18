//
//  PlayerClearer.swift
//  Easy Scores
//
//  Created by Ian Fisher on 11/17/14.
//  Copyright (c) 2014 iFisher. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class PlayerClearer: NSObject, UIActionSheetDelegate {
    
    var managedObjectContext: NSManagedObjectContext?
    
    func clearPlayers(managedObjectContext: NSManagedObjectContext, presentingButton: UIBarButtonItem) {
        self.managedObjectContext = managedObjectContext
        
        let actionSheet = UIActionSheet(title: "Clear all players?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Clear")
        actionSheet.showFromBarButtonItem(presentingButton, animated: true)
    }
    
    private func performClearPlayers() {
        if let moc = self.managedObjectContext {
            let entity = NSEntityDescription.entityForName("Player", inManagedObjectContext: moc)
            
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = entity
            fetchRequest.includesPropertyValues = false
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
            
            var e : NSError? = nil
            let fetchedObjects = moc.executeFetchRequest(fetchRequest, error: &e)
            if let players = fetchedObjects {
                for player in players {
                    moc.deleteObject(player as NSManagedObject)
                }
                var saveError: NSError? = nil
                if !moc.save(&saveError) {
                    NSLog("Error saving context after clearing players: %@", saveError!)
                }
            }
        }
    }
    
    // MARK: UIActionSheetDelegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            self.performClearPlayers()
        }
    }
}
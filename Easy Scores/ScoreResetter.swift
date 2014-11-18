//
//  ScoreResetter.swift
//  Easy Scores
//
//  Created by Ian Fisher on 11/17/14.
//  Copyright (c) 2014 iFisher. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class ScoreResetter: NSObject, UIActionSheetDelegate {
    
    var managedObjectContext: NSManagedObjectContext?
    var tableView: UITableView?
    
    func resetScores(managedObjectContext: NSManagedObjectContext, presentingButton: UIBarButtonItem, tableView: UITableView) {
        self.managedObjectContext = managedObjectContext
        self.tableView = tableView
        
        let actionSheet = UIActionSheet(title: "Reset all scores?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Reset")
        actionSheet.showFromBarButtonItem(presentingButton, animated: true)
    }
    
    private func performResetScores() {
        let entity = NSEntityDescription.entityForName("Player", inManagedObjectContext: self.managedObjectContext!)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.includesPropertyValues = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        var e : NSError? = nil
        let fetchedObjects = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: &e)
        if let players = fetchedObjects as? Array<Player> {
            for player in players  {
                player.score = 0
            }
            var saveError: NSError? = nil
            if !self.managedObjectContext!.save(&saveError) {
                NSLog("Error saving context after resetting scores: %@", saveError!)
            }
        }
        
        for cell in self.tableView!.visibleCells() as Array<PlayerTableViewCell> {
            cell.stepper.value = 0
        }
    }
    
    // MARK: UIActionSheetDelegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            self.performResetScores()
        }
    }
}
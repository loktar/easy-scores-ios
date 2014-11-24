//
//  ScoresViewController.swift
//  Easy Scores
//
//  Created by Ian Fisher on 10/23/14.
//  Copyright (c) 2014 iFisher. All rights reserved.
//

import CoreData
import UIKit

class ScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate, PlayerScoreDelegate {

    @IBOutlet var playersTableView: UITableView!

    let kPlayerCellReuseIdentifier = "kPlayerCellReuseIdentifier"
    
    let coreDataHelper = CoreDataHelper()
    let playerClearer = PlayerClearer()
    let scoreResetter = ScoreResetter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playersTableView.registerNib(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: kPlayerCellReuseIdentifier)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("endEditing"))
        self.view.addGestureRecognizer(tapGesture)
        
        var e: NSError? = nil
        if !self.fetchedResultsController.performFetch(&e) {
            NSLog("error fetching players: \(e)")
        }
    }
    
    func endEditing() {
        self.view.endEditing(true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kPlayerCellReuseIdentifier) as PlayerTableViewCell
        cell.delegate = self
        
        self.configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: UITableViewCell?, indexPath: NSIndexPath) {
        let player = self.fetchedResultsController.objectAtIndexPath(indexPath) as Player
        
        let playerCell = cell as PlayerTableViewCell
        playerCell.configureForPlayer(player)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let name = textField.text
        
        if name.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            textField.resignFirstResponder()
            return true
        }

        if let moc = self.coreDataHelper.managedObjectContext {
            let player = NSEntityDescription.insertNewObjectForEntityForName("Player", inManagedObjectContext: moc) as Player
            player.name = name
            player.score = 0
            player.createdAt = NSDate()
            
            var e: NSError?
            moc.save(&e)
            self.playersTableView.reloadData()
            
            textField.text = ""
        }
        
        return false
    }
    
    @IBAction func clearPlayers(sender: UIBarButtonItem) {
        self.playerClearer.clearPlayers(self.coreDataHelper.managedObjectContext!, presentingButton: sender)
    }
    
    @IBAction func resetScores(sender: UIBarButtonItem) {
        self.scoreResetter.resetScores(self.coreDataHelper.managedObjectContext!, presentingButton: sender, tableView: self.playersTableView)
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        if let moc = self.coreDataHelper.managedObjectContext {
            let entity = NSEntityDescription.entityForName("Player", inManagedObjectContext: moc)

            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = entity
            fetchRequest.fetchBatchSize = 20
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
            
            let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
            frc.delegate = self
            return frc
        }
    
        NSLog("Could not create managed object context; exiting")
        exit(1)
    }()
    
    // MARK: Fetched Results Controller Delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.playersTableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        let tv = self.playersTableView
        
        switch (type) {
        case .Insert:
            tv.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Delete:
            tv.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Update:
            self.configureCell(tv.cellForRowAtIndexPath(indexPath!), indexPath: indexPath!)
        case .Move:
            tv.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            tv.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.playersTableView.endUpdates()
    }
    
    // MARK: PlayerScoreDelegate
    
    func scoreDidUpdate(#playerId: NSManagedObjectID, score: Double) {
        if let moc = self.coreDataHelper.managedObjectContext {
            var error: NSError?
            let player = moc.existingObjectWithID(playerId, error: &error) as Player
            player.score = score

            var saveError: NSError? = nil
            if !moc.save(&saveError) {
                NSLog("Error saving context after resetting scores: %@", saveError!)
            }
        }
    }
}


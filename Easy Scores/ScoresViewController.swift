//
//  ScoresViewController.swift
//  Easy Scores
//
//  Created by Ian Fisher on 10/23/14.
//  Copyright (c) 2014 iFisher. All rights reserved.
//

import CoreData
import UIKit

class ScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet var playersTableView: UITableView!

    let coreDataHelper = CoreDataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playersTableView.registerClass(PlayerTableViewCell.self, forCellReuseIdentifier: "PlayerCell")
        
        var e: NSError? = nil
        if !self.fetchedResultsController.performFetch(&e) {
            NSLog("error fetching players: \(e)")
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseId = "PlayerCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseId) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell()
        }
        
        self.configureCell(cell, indexPath: indexPath)
        
        return cell!
    }
    
    func configureCell(cell: UITableViewCell?, indexPath: NSIndexPath) {
        let player = self.fetchedResultsController.objectAtIndexPath(indexPath) as Player
        cell?.textLabel.text = player.name
    }
    
    @IBAction func addPlayerFromTextField(sender: UITextField) {
        let name = sender.text
        
        if name.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            return
        }
        
        if let moc = self.coreDataHelper.managedObjectContext {
            let player = NSEntityDescription.insertNewObjectForEntityForName("Player", inManagedObjectContext: moc) as Player
            player.name = sender.text
            player.score = 0
            player.createdAt = NSDate()

            var e: NSError?
            moc.save(&e)
            self.playersTableView.reloadData()
            
            sender.text = ""
        }
    }
    
    @IBAction func clearPlayers(sender: UIBarButtonItem) {
        // TODO confirm delete
        if let moc = self.coreDataHelper.managedObjectContext {
            let entity = NSEntityDescription.entityForName("Player", inManagedObjectContext: moc)

            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = entity
            fetchRequest.includesPropertyValues = false
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
            
            var e : NSError? = nil
            let fetchedObjects = moc.executeFetchRequest(fetchRequest, error: &e)
            if let os = fetchedObjects {
                for o in os {
                    moc.deleteObject(o as NSManagedObject)
                }
            }
        }
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
}


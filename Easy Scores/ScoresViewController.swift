//
//  ViewController.swift
//  Easy Scores
//
//  Created by Ian Fisher on 10/23/14.
//  Copyright (c) 2014 iFisher. All rights reserved.
//

import CoreData
import UIKit

class ScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var playersTableView: UITableView!

    let coreDataHelper = CoreDataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let player = self.fetchedResultsController.objectAtIndexPath(indexPath) as Player
        cell?.textLabel.text = player.name
        
        return cell!
    }
    
    @IBAction func addPlayerFromTextField(sender: UITextField) {
        if let moc = self.coreDataHelper.managedObjectContext {
            let player = NSEntityDescription.insertNewObjectForEntityForName("Player", inManagedObjectContext: moc) as Player
            player.name = sender.text
            player.score = 0

            var e: NSError?
            moc.save(&e)
            self.playersTableView.reloadData()
            
            sender.text = ""
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        if let moc = self.coreDataHelper.managedObjectContext {
            let entity = NSEntityDescription.entityForName("Player", inManagedObjectContext: moc)

            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = entity
            fetchRequest.fetchBatchSize = 20
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        }
    
        NSLog("Could not create managed object context; exiting")
        exit(1)
    }()
}


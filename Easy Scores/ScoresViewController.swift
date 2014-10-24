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

    var coreDataHelper = CoreDataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var e: NSError? = nil
        if self.fetchedResultsController.performFetch(&e) {
            NSLog("error fetching players: \(e)")
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections[section].count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseId = "PlayerCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseId) as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell()
        }
        
        cell?.textLabel.text = "A cell"
        
        return cell!
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let frc = NSFetchedResultsController()
        
        let fetchRequest = NSFetchRequest()
        if let moc = self.coreDataHelper.managedObjectContext {
            let entity = NSEntityDescription.entityForName("Player", inManagedObjectContext: moc)
            fetchRequest.entity = entity
        }
    
        return frc
    }()
}


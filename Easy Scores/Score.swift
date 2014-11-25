//
//  Score.swift
//  Easy Scores
//
//  Created by Ian Fisher on 11/24/14.
//  Copyright (c) 2014 iFisher. All rights reserved.
//

import CoreData
import Foundation

typealias ScoreValue = Double

class Score {
    var coreDataHelper: CoreDataHelper!
    
    init (coreDataHelper: CoreDataHelper) {
        self.coreDataHelper = coreDataHelper
    }
    
    func topScore() -> ScoreValue {
        if let moc = self.coreDataHelper.managedObjectContext {
            let keyPathExpression = NSExpression(forKeyPath: "score")
            let maxScoreExpression = NSExpression(forFunction: "max:", arguments: [keyPathExpression])
            
            let desc = NSExpressionDescription()
            desc.name = "maxScore"
            desc.expression = maxScoreExpression
            desc.expressionResultType = .DoubleAttributeType
            
            let entity = NSEntityDescription.entityForName("Player", inManagedObjectContext: moc)
            
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = entity
            fetchRequest.fetchBatchSize = 1
            fetchRequest.propertiesToFetch = [desc]
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]
            
            var e: NSError?
            let results = moc.executeFetchRequest(fetchRequest, error: &e)
            if results?.count > 0 {
                let player = results?.first as Player
                return player.score.doubleValue
            }
        }
        
        return self.minimumScore()
    }
    
    func minimumScore() -> ScoreValue {
        return 0
    }
    
    func isWinning(player: Player) -> Bool {
        return player.score.doubleValue == self.topScore()
    }
}
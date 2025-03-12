//
//  DataController.swift
//  Quoted
//
//  Created by Dawson McCall on 10/6/23.
//

import CoreData
import Foundation

class DataController {
    
    let persistentContainer = NSPersistentContainer(name: "QuotedData")
    static let shared: DataController = DataController()
    
    private init() {
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Unable to load Core Data. \(error.localizedDescription)")
            }
        }
        
        self.persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}

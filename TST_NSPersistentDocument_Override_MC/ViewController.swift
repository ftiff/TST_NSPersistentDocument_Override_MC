//
//  ViewController.swift
//  TST_NSPersistentDocument_Override_MC
//
//  Created by Francois Levaux on 17.09.17.
//  Copyright © 2017 Francois Levaux. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @objc dynamic var mainContext: NSManagedObjectContext!
    var bgContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(ViewController.mergeChangesFromBackground(notification:)),
                                                       name: NSNotification.Name.NSManagedObjectContextDidSave,
                                                       object: self.bgContext)
//                NotificationCenter.default.addObserver(self,
//                                                       selector: #selector(ViewController.mergeChangesFromMain(notification:)),
//                                                       name: NSNotification.Name.NSManagedObjectContextDidSave,
//                                                       object: self.mainContext)
    }
    
    @objc func mergeChangesFromBackground(notification: Notification) {
        self.mainContext.mergeChanges(fromContextDidSave: notification)
    }
    
//    @objc func mergeChangesFromMain(notification: Notification) {
//        self.bgContext.mergeChanges(fromContextDidSave: notification)
//    }
    
    override func viewDidAppear() {
        self.bgContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.bgContext.parent = self.mainContext
        
        self.bgContext.perform {
            let newEntity: Entity = Entity(context: self.bgContext)
            newEntity.name = "TEST"
            do {
                try self.bgContext.save()
            } catch {
                DispatchQueue.main.async {
                    self.presentError(error)
                }
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


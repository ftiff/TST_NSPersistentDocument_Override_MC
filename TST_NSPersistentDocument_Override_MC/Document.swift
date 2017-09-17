//
//  Document.swift
//  TST_NSPersistentDocument_Override_MC
//
//  Created by Francois Levaux on 17.09.17.
//  Copyright © 2017 Francois Levaux. All rights reserved.
//

import Cocoa

class Document: NSPersistentDocument {

    override init() {
        super.init()
        
        // Set managedObjectContext to mainQueue
        // https://gist.github.com/smic/4632383
        
        guard let context = self.managedObjectContext else { fatalError("no MOC") }
        if context.concurrencyType != NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType {
            guard let undoManager = context.undoManager else { fatalError("no undoManager") }
            guard let persistentStoreCoordinator = context.persistentStoreCoordinator else { fatalError("no persistentStoreCoordinator") }
            let newContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            newContext.persistentStoreCoordinator = persistentStoreCoordinator
            newContext.undoManager = undoManager
            self.managedObjectContext = newContext
        }
        
        assert(self.managedObjectContext?.concurrencyType == NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    }

    override class var autosavesInPlace: Bool {
        return true
    }
    


    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        guard let context = self.managedObjectContext else { fatalError("context is nil") }
        guard let viewController = windowController.contentViewController  else { fatalError("cannot get contentViewcontroller") }
        (viewController as! ViewController).mainContext = context
        self.addWindowController(windowController)
    }

}

//
//  CoreDataMapVC.swift
//  VirtualTourist
//
//  Created by Keisuke Kishida on 8/15/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit
import MapKit
import CoreData

extension VTMapViewController {
    
    func setLocation(lat: Double, lon: Double) {
        
        // Get the stack
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "Location")
        fr.sortDescriptors = [NSSortDescriptor(key: "lat", ascending: true), NSSortDescriptor(key: "lon", ascending: true)]
        
        // Create the FetchedResultsController
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Create a new notebook... and Core Data takes care of the rest!
        let newLocation = Location(lat: lat, lon: lon, context: fetchedResultsController.managedObjectContext)
        print("Just created a location: \(newLocation)")
        
        stack.save()
        
    }
    

    
}
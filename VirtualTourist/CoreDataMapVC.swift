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
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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
    
    func loadLocations() {
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "Location")
        fr.returnsObjectsAsFaults = false
        
        do {
            let results: Array = try stack.context.executeFetchRequest(fr)
            if results.count > 0  {
                
                for i in 0...results.count-1 {
                    
                    let latitude = results[i].valueForKey("lat") as! Double
                    let longtitude = results[i].valueForKey("lon") as! Double
                    
                    let myCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                    let myPin = MKPointAnnotation()
                    myPin.coordinate = myCoordinate
                    self.mapView.addAnnotation(myPin)
                }
            }
        } catch let error as NSError {
            print("READ ERROR:\(error.localizedDescription)")
        }
        
    }
    
    func findLocation(lat: Double, lon: Double) -> Location? {
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "Location")
        fr.returnsObjectsAsFaults = false
        
        do {
            let results: Array = try stack.context.executeFetchRequest(fr)
            if results.count > 0 {
                
                for i in 0...results.count-1 {
                    
                    let latitude = results[i].valueForKey("lat") as! Double
                    let longtitude = results[i].valueForKey("lon") as! Double
                    
                    if latitude == lat && longtitude == lon {
                        
                        let location = results[i] as! Location
                        return location
                        
                    }
                }
            }
        } catch let error as NSError {
            print("FETCH ERROR:\(error.localizedDescription)")
        }
        
        return nil

    }
    
    func deleteLocation(location: Location) {
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "Location")
        fr.returnsObjectsAsFaults = false
        
        do {
            let results: Array = try stack.context.executeFetchRequest(fr)
            if results.count > 0 {
                stack.context.deleteObject(location)
                stack.save()
            }
        } catch let error as NSError {
            print("FETCH ERROR:\(error.localizedDescription)")
        }
        
    }
    
}
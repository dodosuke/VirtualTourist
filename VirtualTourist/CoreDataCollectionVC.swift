//
//  CoreDataCollectionVC.swift
//  VirtualTourist
//
//  Created by Keisuke Kishida on 8/15/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit
import CoreData

extension VTCollectionViewController {
    
    func storePhotos(image: UIImage?, location: Location) {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "FlickrImages")
        fr.sortDescriptors = [NSSortDescriptor(key: "image", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let _ = FlickrImages(image: UIImagePNGRepresentation(image!)!, location:location, context: fetchedResultsController.managedObjectContext)
        
        stack.save()
        
    }
    
    func getPhotos(location: Location) -> [FlickrImages] {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "FlickrImages")
        fr.predicate = NSPredicate(format: "photos = %@", argumentArray: [location])
        
        do {
            let results: Array = try stack.context.executeFetchRequest(fr)
            if results.count > 0  {
                
                let photos = results as! [FlickrImages]
                return photos
                
            }
        } catch let error as NSError {
            print("READ ERROR:\(error.localizedDescription)")
        }
        
        return []
        
    }
    
    func deletePhoto(photos: [FlickrImages]) {
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "FlickrImages")
        fr.returnsObjectsAsFaults = false
        
        do {
            let results: Array = try stack.context.executeFetchRequest(fr)
            if results.count > 0 {
                for photo in photos {
                    stack.context.deleteObject(photo)
                    stack.save()
                }
            }
        } catch let error as NSError {
            print("FETCH ERROR:\(error.localizedDescription)")
        }
        
    }
    
}
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
    
    func storePhotos(image: UIImage?, location: Location) -> FlickrImages {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "FlickrImages")
        fr.sortDescriptors = [NSSortDescriptor(key: "image", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let newPhoto = FlickrImages(image: UIImagePNGRepresentation(image!)!, location:location, context: fetchedResultsController.managedObjectContext)
        
        stack.save()
        return newPhoto
        
    }
    
    func loadPhotos(location: Location) -> [Int:FlickrImages] {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "FlickrImages")
        fr.sortDescriptors = [NSSortDescriptor(key: "image", ascending: true)]
       
        
        do {
            let results: Array = try stack.context.executeFetchRequest(fr)
            if results.count > 0  {
                
                var photos: [Int:FlickrImages] = [:]
                
                for i in 0...results.count-1 {
                    photos[i] = results[i] as? FlickrImages
                }
                return photos
            }
        } catch let error as NSError {
            print("READ ERROR:\(error.localizedDescription)")
        }
        
        return [:]
        
    }
    
    func deletePhoto(photos: [FlickrImages], location: Location) {
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "FlickrImages")
        fr.sortDescriptors = [NSSortDescriptor(key: "image", ascending: true)]
        fr.predicate = NSPredicate(format: "photos = %@", argumentArray: [location])
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
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
    
    func loadPhotos(location: Location) -> [FlickrImages?] {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "FlickrImages")
        fr.predicate = NSPredicate(format: "photos = %@", argumentArray: [location])
        
        do {
            let results: Array = try stack.context.executeFetchRequest(fr)
            if results.count > 0  {
                
                var photos: [FlickrImages?] = []
                
                for i in 0...results.count-1 {
                    let photo = results[i] as! FlickrImages
                    photos.append(photo)
                }
                
                return photos
                
            }
        } catch let error as NSError {
            print("READ ERROR:\(error.localizedDescription)")
        }
        
        return [FlickrImages?](count:21, repeatedValue: nil)
        
    }
    
    func deletePhoto(photos: [FlickrImages?]) {
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "FlickrImages")
        fr.returnsObjectsAsFaults = false
        
        do {
            let results: Array = try stack.context.executeFetchRequest(fr)
            if results.count > 0 {
                for photo in photos {
                    stack.context.deleteObject(photo!)
                    stack.save()
                }
            }
        } catch let error as NSError {
            print("FETCH ERROR:\(error.localizedDescription)")
        }
        
    }
    
}
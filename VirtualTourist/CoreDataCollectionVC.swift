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
    
    func getPhotos(image: UIImage?) {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "FlickrImages")
        fr.sortDescriptors = [NSSortDescriptor(key: "image", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let photo = FlickrImages(image: UIImagePNGRepresentation(image!)!, context: fetchedResultsController!.managedObjectContext)
        print(photo)
        
    }
    
}
//
//  VTCollectionViewController.swift
//  VirtualTourist
//
//  Created by Keisuke Kishida on 8/7/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit
import CoreData

class VTCollectionViewController: UICollectionViewController {

    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var lat: Double?
    var lon: Double?
    var fetchedResultsController: NSFetchedResultsController?
    
    var imageCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton.enabled = false
        
//      For formatting the collection view
        let space: CGFloat = 3.0
        let dimension: CGFloat = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
//        for handling coredata
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "FlickrImages")
        fr.sortDescriptors = [NSSortDescriptor(key: "image", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromAllNotifications()
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 21
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("VTCollectionViewCell", forIndexPath: indexPath) as! VTCollectionViewCell
        
        cell.backgroundColor = UIColor.grayColor()
        
        if let cacheImage = imageCache.objectForKey(indexPath) {
            if let _ = cell.photoImageView.image {
                cell.photoImageView.image = cacheImage as? UIImage
            }
        } else {
            
            cell.activityIndicator.alpha = 1.0
            cell.activityIndicator.startAnimating()
            
            FlickrClient.sharedInstance().displayImageFromFlickrBySearch(lat!, lon:lon!) {(image, errorString) in
                if errorString == nil {
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        cell.photoImageView.image = image!
                        self.imageCache.setObject(image!, forKey: indexPath)
                        cell.activityIndicator.alpha = 0.0
                        cell.activityIndicator.stopAnimating()
                        
//                        let photo = FlickrImages(image: UIImagePNGRepresentation(image!)!, context: self.fetchedResultsController!.managedObjectContext)
//                        print(photo)
            
                    })
                } else {
                    cell.labelForError.text = "No image"
                }
            }
        }
        
        return cell
    }
    
    
    @IBAction func backToMap(sender: AnyObject) {
        
        navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    @IBAction func refreshCollection(sender: AnyObject) {
        
    }
    
}


// MARK: - ViewController (Notifications)

extension VTCollectionViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension VTCollectionViewController {
    
}




//
//  VTCollectionViewController.swift
//  VirtualTourist
//
//  Created by Keisuke Kishida on 8/7/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

class VTCollectionViewController: UICollectionViewController {

    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!

    
    var lat: Double?
    var lon: Double?
    
    // MARK: Life Cycle
    
    var imageCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton.enabled = false
        
        let space: CGFloat = 3.0
        let dimension: CGFloat = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
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
        
        let methodParameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.BoundingBox: bboxString(),
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        cell.backgroundColor = UIColor.grayColor()
        
        if let cacheImage = imageCache.objectForKey(indexPath) {
            if let _ = cell.photoImageView.image {
                cell.photoImageView.image = cacheImage as? UIImage
            }
        } else {
            
            cell.activityIndicator.alpha = 1.0
            cell.activityIndicator.startAnimating()
            
            FlickrClient.sharedInstance().displayImageFromFlickrBySearch(methodParameters) {(image, errorString) in
                if errorString == nil {
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        cell.photoImageView.image = image!
                        self.imageCache.setObject(image!, forKey: indexPath)
                        cell.activityIndicator.alpha = 0.0
                        cell.activityIndicator.stopAnimating()
            
                    })
                } else {
                    cell.labelForError.text = "Error"
                }
            }
        }
        
        return cell
    }
    
    private func bboxString() -> String {
        // ensure bbox is bounded by minimum and maximums
        if let latitude = lat, let longitude = lon {
            let minimumLon = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
            let minimumLat = max(latitude - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
            let maximumLon = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
            let maximumLat = min(latitude + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
            return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
        } else {
            return "0,0,0,0"
        }
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




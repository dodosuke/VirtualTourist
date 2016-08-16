//
//  VTCollectionViewController.swift
//  VirtualTourist
//
//  Created by Keisuke Kishida on 8/7/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class VTCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate {

    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var newCollectionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    var lat: Double?
    var lon: Double?
    var myPin: MKAnnotation?
    var fetchedResultsController: NSFetchedResultsController?
    
    var imageCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        deleteButton.enabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        mapView.delegate = self
        
//      For formatting the collection view
        let space: CGFloat = 3.0
        let dimension: CGFloat = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
//      For mapview
        let myCoordinate = myPin!.coordinate
        let myLatDist : CLLocationDistance = 400
        let myLonDist : CLLocationDistance = 400
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, myLatDist, myLonDist);
        mapView.setRegion(myRegion, animated: true)
        mapView.addAnnotation(myPin!)

    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 21
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
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
                print("fff")
                if errorString == nil {
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        cell.photoImageView.image = image!
                        self.imageCache.setObject(image!, forKey: indexPath)
                        cell.activityIndicator.alpha = 0.0
                        cell.activityIndicator.stopAnimating()
                        
                        self.getPhotos(image)
            
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
    
    
}






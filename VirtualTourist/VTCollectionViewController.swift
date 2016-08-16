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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionButton: UIButton!
    
    
    var lat: Double?
    var lon: Double?
    var myPin: MKAnnotation?
    var location: Location?
    
    var imageCache = NSCache()
    var photos: [FlickrImages] = []
    var selectedCells:[Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lat = myPin!.coordinate.latitude
        lon = myPin!.coordinate.longitude

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        mapView.delegate = self
        
        photos = getPhotos(location!)
        if photos != [] {
            selectedCells = [Bool](count:photos.count, repeatedValue:false)
        } else {
            selectedCells = [Bool](count:21, repeatedValue:false)
        }
        
//      For formatting the collection view
        let space: CGFloat = 3.0
        let dimension: CGFloat = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
//      For mapview
        let myCoordinate = myPin!.coordinate
        let myLatDist : CLLocationDistance = 1000
        let myLonDist : CLLocationDistance = 1000
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, myLatDist, myLonDist);
        mapView.setRegion(myRegion, animated: true)
        mapView.addAnnotation(myPin!)

    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if photos == [] {
            return 21
        } else {
            return photos.count
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("VTCollectionViewCell", forIndexPath: indexPath) as! VTCollectionViewCell
        
        if photos == [] {
            
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
                            
                            self.storePhotos(image, location: self.location!)
                            self.photos = self.getPhotos(self.location!)
                            
                        })
                    } else {
                        cell.labelForError.text = "No image"
                    }
                }
            }
            
            return cell
            
        } else {
            
            let flickrImage = photos[indexPath.row]
            cell.photoImageView.image = UIImage(data: flickrImage.image!)
            
            if selectedCells[indexPath.row] == true {
                cell.alpha = 0.5
            } else {
                cell.alpha = 1.0
            }
            
            return cell
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectCells(collectionView, indexPath: indexPath)

    }
    
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectCells(collectionView, indexPath: indexPath)
        
    }
    
    func selectCells(collectionView: UICollectionView, indexPath: NSIndexPath) {
        
        selectedCells[indexPath.row] = !selectedCells[indexPath.row]
        
        print(photos.count)
        if selectedCells == [Bool](count:photos.count, repeatedValue:false) {
            collectionButton.setTitle("New Collection", forState: .Normal)
        } else {
            collectionButton.setTitle("Remove Selected Photo(s)", forState: .Normal)
        }
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)!
        
        if selectedCells[indexPath.row] == true {
            cell.alpha = 0.5
        } else {
            cell.alpha = 1.0
        }
        
    }
    
    
    @IBAction func backToMap(sender: AnyObject) {
        
        navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    @IBAction func pressCollectionButton(sender: AnyObject) {
        
        var photosForDelete: [FlickrImages] = []
        
        if collectionButton.titleLabel!.text == "New Collection" {
            photosForDelete = photos
        } else if collectionButton.titleLabel!.text == "Remove Selected Photo(s)" {
            for i in 0...photos.count-1 {
                if selectedCells[i] {
                    photosForDelete.append(photos[i])
                }
            }
        }
        
        deletePhoto(photosForDelete)
        
        photos = getPhotos(location!)
        selectedCells = [Bool](count:photos.count, repeatedValue:false)
        collectionButton.setTitle("New Collection", forState: .Normal)
        collectionView.reloadData()
        
    }
    
    
    

    
    
}






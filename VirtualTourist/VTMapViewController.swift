//
//  VTMapViewController.swift
//  VirtualTourist
//
//  Created by Keisuke Kishida on 8/9/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class VTMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var labelForDelete: UILabel!
    
    var lat:Double?
    var lon:Double?
    var editMode:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(VTMapViewController.recognizeLongPress(_:)))
        mapView.addGestureRecognizer(myLongPress)
        
        loadLocations()
        
    }
    
    func recognizeLongPress(sender: UILongPressGestureRecognizer) {
        
        if sender.state != UIGestureRecognizerState.Began {
            return
        }
        
        let location = sender.locationInView(mapView)
        
        let myCoordinate: CLLocationCoordinate2D = mapView.convertPoint(location, toCoordinateFromView: mapView)
        let myPin: MKPointAnnotation = MKPointAnnotation()
        myPin.coordinate = myCoordinate
        mapView.addAnnotation(myPin)
        
        setLocation(myCoordinate.latitude, lon: myCoordinate.longitude)
        
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
    
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        let location:Location = findLocation(view.annotation!.coordinate.latitude, lon: view.annotation!.coordinate.longitude)!
        
        if editMode {
            mapView.removeAnnotation(view.annotation!)
            deleteLocation(location)
        } else {
            recallCollectionView(view, location: location)
        }

    }
    
    @IBAction func changeMode(sender: AnyObject) {
        
        if editMode {
            editMode = false
            editButton.title = "Edit"
            labelForDelete.alpha = 0
        } else {
            editMode = true
            editButton.title = "Done"
            labelForDelete.alpha = 1
        }
    }
    
    private func recallCollectionView(view: MKAnnotationView, location: Location) {
        
        let myPin = view.annotation!
        let collectionViewer = storyboard!.instantiateViewControllerWithIdentifier("VTCollectionViewController") as! VTCollectionViewController
        
        collectionViewer.myPin = myPin
        collectionViewer.location = location
        
        navigationController?.pushViewController(collectionViewer, animated: true)
        
    }
    
}
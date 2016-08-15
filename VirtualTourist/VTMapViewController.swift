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
    
    var lat:Double?
    var lon:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(VTMapViewController.recognizeLongPress(_:)))
        mapView.addGestureRecognizer(myLongPress)
        
        loadDataToMap()
        
    }
    
    func loadDataToMap() {
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "Location")
        fr.returnsObjectsAsFaults = false
        
        var locations = []
        
        do {
            let results = try stack.context.executeFetchRequest(fr)
            if (results.count > 0 ) {
                locations = results
            }
        } catch let error as NSError {
            print("READ ERROR:\(error.localizedDescription)")
        }
        
        for i in 0...locations.count-1 {
            
            let latitude = locations[i].valueForKey("lat") as! Double
            let longtitude = locations[i].valueForKey("lon") as! Double
            
            let myCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            let myPin = MKPointAnnotation()
            myPin.coordinate = myCoordinate
            self.mapView.addAnnotation(myPin)
        }
        
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
        
        let collectionViewer = storyboard!.instantiateViewControllerWithIdentifier("VTCollectionViewController") as! VTCollectionViewController
        collectionViewer.lat = view.annotation?.coordinate.latitude
        collectionViewer.lon = view.annotation?.coordinate.longitude
            
        navigationController?.pushViewController(collectionViewer, animated: true)
    }
    
}
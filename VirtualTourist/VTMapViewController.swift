//
//  VTMapViewController.swift
//  VirtualTourist
//
//  Created by Keisuke Kishida on 8/9/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit
import MapKit

class VTMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var lat:Double? = nil
    var lon:Double? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(VTMapViewController.recognizeLongPress(_:)))
        
        mapView.addGestureRecognizer(myLongPress)
    }
    
    func recognizeLongPress(sender: UILongPressGestureRecognizer) {
        
        if sender.state != UIGestureRecognizerState.Began {
            return
        }
        
        let location = sender.locationInView(mapView)
        let myCoordinate: CLLocationCoordinate2D = mapView.convertPoint(location, toCoordinateFromView: mapView)

        lat = myCoordinate.latitude
        lon = myCoordinate.longitude
        print(lat!, lon!)
        let myPin: MKPointAnnotation = MKPointAnnotation()
        
        myPin.coordinate = myCoordinate
        myPin.title = "Collection"
        mapView.addAnnotation(myPin)
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        if control == view.rightCalloutAccessoryView {
            
            let collectionViewer = storyboard!.instantiateViewControllerWithIdentifier("VTCollectionViewController") as! VTCollectionViewController
            collectionViewer.lat = lat
            collectionViewer.lon = lon
            navigationController?.pushViewController(collectionViewer, animated: true)
            
        }
    }
    
}
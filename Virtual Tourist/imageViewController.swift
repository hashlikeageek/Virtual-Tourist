//
//  imageViewController.swift
//  Virtual Tourist
//
//  Created by Ashutosh Kumar Sai on 31/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class imageViewController : UIViewController, MKMapViewDelegate
{
     var passedCordinates: CLLocationCoordinate2D!
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(passedCordinates)")
        let initialLocation = CLLocation(latitude: passedCordinates.latitude, longitude: passedCordinates.longitude)
        mapView.delegate = self
        centerMapOnLocation(location: initialLocation)
        addpin()
        
        
    pinphotos()
           }
    
    func pinphotos(){
        
     photoURL()
    }
    
   
    func photoURL()
    {
        
    }
    
    
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addpin()
    {
        let pins = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: passedCordinates.latitude, longitude:passedCordinates.longitude)
        pins.coordinate = centerCoordinate
        mapView.addAnnotation(pins)
    }
}

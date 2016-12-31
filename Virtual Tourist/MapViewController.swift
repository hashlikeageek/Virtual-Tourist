//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Ashutosh Kumar Sai on 28/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var gesture : UILongPressGestureRecognizer!
    var context:NSManagedObjectContext!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gesture = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.newPin(sender :)))
        gesture.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(gesture)
      
        let pins = CoreDataClient.sharedInstance().addPins()
        mapView.addAnnotations(pins)

        
        
        
    }
    
    
    func newPin(sender: UILongPressGestureRecognizer){
        if sender.state == .began
        {
            let tPoint = sender.location(in: mapView)
            let tCoordinate = mapView.convert(tPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = tCoordinate
            mapView.addAnnotation(annotation)
           CoreDataClient.sharedInstance().savePin(lat: Double(tCoordinate.latitude), lon: Double(tCoordinate.longitude))
        }
        
        return
        
    }
    
    
    



}


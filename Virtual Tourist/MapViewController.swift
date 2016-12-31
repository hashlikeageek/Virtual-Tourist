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

class MapViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var gesture : UILongPressGestureRecognizer!
    var context:NSManagedObjectContext!
    var passingCordinates: CLLocationCoordinate2D!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gesture = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.newPin(sender :)))
        gesture.minimumPressDuration = 0.5
        mapView.delegate = self
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
    
    //annotationView method
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("annoation entry")
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    //now we write a function to call collectionViewController and pass "passingCordinates" to it
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        print("in the didSelect")
         let annotation = view.annotation
         passingCordinates = annotation?.coordinate
         performSegue(withIdentifier: "showImage", sender: self)
         mapView.deselectAnnotation(view.annotation, animated: false)
    }
    
   
    
    //we shall override the segue in order to pass cordinates to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    
    {
        

        let secondViewController = segue.destination as! imageViewController
        secondViewController.passedCordinates = passingCordinates
    }
    
    
    



}


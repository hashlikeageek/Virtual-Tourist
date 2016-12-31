//
//  mapVC.swift
//  Virtual Tourist
//
//  Created by Ashutosh Kumar Sai on 28/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class mapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var longpress : UILongPressGestureRecognizer!
    var context : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        longpress = UILongPressGestureRecognizer(target: self, action: #selector(mapVC.addPin(sender:)))
        longpress.minimumPressDuration = 0.4
        mapView.addGestureRecognizer(longpress)
        
        
    }
    
    func addPin(sender: UILongPressGestureRecognizer)
    {
        if sender.state != .began
        {
            print("Error")
        }
        else
        {
            print("one")
           let touchLocation = sender.location(in: mapView)
            let cordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            let newpin = MKPointAnnotation()
            newpin.coordinate = cordinate
           
            print("two")
            
            _ = Pin(longitude: cordinate.longitude, latitude: cordinate.latitude, context: context)
            do{
                print("In addnewpin")
            try context.save()
            }
            catch {
                print("Error")
            }
             mapView.addAnnotation(newpin)
            
            
        }
    }

}

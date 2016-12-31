//
//  CoreDataClient.swift
//  Virtual Tourist
//
//  Created by Ashutosh Kumar Sai on 28/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class CoreDataClient {
    
    let stack = CoreDataStack(modelName: "CoreDataModel")!
    let context:NSManagedObjectContext
    
    init() {
        context = stack.context
    }
    
    
    
    func addPins()->[MKPointAnnotation] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        var pins = [MKPointAnnotation]()
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            for pin in searchResults as! [NSManagedObject] {
                let latitude = pin.value(forKey: "latitude") as? CLLocationDegrees
                let longitude = pin.value(forKey: "longitude") as? CLLocationDegrees
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                pins.append(annotation)
            }
            
        } catch {
            print("Error in getting pins")
        }
        return pins
    }
    
    
    
    func savePin(lat:Double, lon:Double) {
        let pin = Pin(context: stack.context)
        pin.latitude = lat
        pin.longitude = lon
        do{
           try stack.context.save()
        }
        catch
        {
            print("error in saving context")
        }
        
        
    }
    
    
        class func sharedInstance() -> CoreDataClient {
        struct Singleton {
            static var sharedInstance = CoreDataClient()
        }
        return Singleton.sharedInstance
    }
    
}

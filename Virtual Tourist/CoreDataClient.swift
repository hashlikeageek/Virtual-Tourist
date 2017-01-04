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
    
    // lets deal with photos
    
    func photoObj(urlString:String, pin:Pin) ->Photo{
        let photo = Photo(context: stack.context)
        photo.url = urlString
        pin.addToPhoto(photo)
        return photo
    }
    
    func loadPhoto(_ selectedPin: Pin) -> [Photo]{
        
        let photoRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        photoRequest.predicate = NSPredicate(format: "pin = %@", selectedPin)
        
        let photos = try! context.fetch(photoRequest) as! [Photo]
         return photos
    }

    func selectPin(_ lat:Double, lon:Double) -> Pin?{
        let pinRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        
        pinRequest.predicate = NSPredicate(format: "latitude = %lf AND longitude = %lf", lat, lon)
        
         let pins = try? context.fetch(pinRequest) as! [Pin]
        
            if pins?.count == 1{
                return pins?[0]
            } else {
                print("Error in selecting pin")
            }
        
        return nil
        
    }
    
    func NewPhotoObj(urlString:String, selectedPin:Pin) ->Photo{
        let photo = Photo(context: stack.context)
        photo.url = urlString
        selectedPin.addToPhoto(photo)
        return photo
    }
    
    
    func deleteAllPhotosForPin(_ selectedPin: Pin){
        let photos = loadPhoto(selectedPin)
        for photo in photos{
            context.delete(photo)
        }
        do{
            try stack.context.save()
        }
        catch
        {
            print("error in saving context")
        }

    }
    
    func deletePhotos(_ photos: [Photo]){
        for photo in photos{
            context.delete(photo)
        }
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

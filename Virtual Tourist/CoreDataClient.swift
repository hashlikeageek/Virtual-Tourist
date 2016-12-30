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
    
    static let shared = CoreDataClient()
    
    let stack = CoreDataStack(modelName: "CoreDataModel")!
    let context:NSManagedObjectContext
    
    private init() {
        context = stack.context
    }
    
    
        func storePin(lat:Double, lon:Double) {
        let pin = Pin(context: stack.context)
        pin.latitude = lat
        pin.longitude = lon
      
    }
    
    class func sharedInstance() -> CoreDataClient {
        struct Singleton {
            static var sharedInstance = CoreDataClient()
        }
        return Singleton.sharedInstance
    }
}

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

class imageViewController : UIViewController, MKMapViewDelegate,  UICollectionViewDelegate, UICollectionViewDataSource
{
     var passedCordinates: CLLocationCoordinate2D!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
     var page = 1
    var selectedPin:Pin!
    var photoData = [Photo]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(passedCordinates)")
        let initialLocation = CLLocation(latitude: passedCordinates.latitude, longitude: passedCordinates.longitude)
        mapView.delegate = self
        centerMapOnLocation(location: initialLocation)
        self.collectionView.reloadData()
        addpin()
        pinphotos()
           }
    
    
    func pinphotos(){
        print("in pinphoto")
        if let pin = CoreDataClient.sharedInstance().selectPin(passedCordinates.latitude, lon: passedCordinates.longitude){
            selectedPin = pin
            photoData = CoreDataClient.sharedInstance().loadPhoto(pin)
            if photoData.count > 0 {
                self.collectionView.reloadData()
            } else {
                photoURL()
            }
        }

        
     
    }
    
   
    func photoURL()
    {
         print("in photourl")
        flickrClient.sharedInstance().searchByLatLon(lat: passedCordinates.latitude, lon: passedCordinates.longitude, page: page, completionHandler: { (urls) in
            
            let urls = urls
            if urls?.count == 0{
                
              
                if self.page > 1{
                   
                    self.page -= 1
                    self.photoURL()
                }
                
              
            } else {
                
                self.page += 1
                
                
                for url in urls! {
                    let photo = CoreDataClient.sharedInstance().NewPhotoObj(urlString: url, selectedPin: self.selectedPin)
                    self.photoData.append(photo)
                }
                self.collectionView.reloadData()
            }
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("in collectionView")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
                
        
        let photoObject = photoData[indexPath.row]
        
        
        if let imgData = photoObject.photoData{
            guard let image = UIImage(data: imgData as Data) else{
                return cell
            }
            cell.imageView.image = image
             print("got the image")
           
        } else {
            if let url = photoObject.url{
                flickrClient.sharedInstance().downloadImage(url: url, completionHandler: { ( imgData) in
                    
                    guard let imgData = imgData else {
                        return
                    }
                    
                    guard let image = UIImage(data: imgData as Data) else{
                        return
                    }
                    
                    photoObject.photoData = imgData as NSData
                    do
                    {
                     try CoreDataClient.sharedInstance().stack.context.save()
                    }
                    catch
                    {
                        print("Error in saving context")
                    }
                    cell.imageView.image = image
                })
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("inside count")
        return photoData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let removedPhoto = photoData.remove(at: indexPath.row)
        CoreDataClient.sharedInstance().deletePhotos([removedPhoto])
        collectionView.deleteItems(at: [indexPath])
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

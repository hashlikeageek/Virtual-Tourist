//
//  flickrClient.swift
//  Virtual Tourist
//
//  Created by Ashutosh Kumar Sai on 31/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import Foundation

class flickrClient : NSObject
{
    func searchByLatLon(lat:Double, lon: Double) {
        
            let methodParameters = [
                flickrConstant.FlickrParameterKeys.Method: flickrConstant.FlickrParameterValues.SearchMethod,
                flickrConstant.FlickrParameterKeys.APIKey: flickrConstant.FlickrParameterValues.APIKey,
                flickrConstant.FlickrParameterKeys.Lat : "\(lat)",
                flickrConstant.FlickrParameterKeys.Lon: "\(lon)",
              
                flickrConstant.FlickrParameterKeys.SafeSearch: flickrConstant.FlickrParameterValues.UseSafeSearch,
                flickrConstant.FlickrParameterKeys.Extras: flickrConstant.FlickrParameterValues.MediumURL,
                flickrConstant.FlickrParameterKeys.Format: flickrConstant.FlickrParameterValues.ResponseFormat,
                flickrConstant.FlickrParameterKeys.NoJSONCallback: flickrConstant.FlickrParameterValues.DisableJSONCallback
            ]
        
        displayImageFromFlickrBySearch(methodParameters as [String:AnyObject])
        }
    
    

    
    private func displayImageFromFlickrBySearch(_ methodParameters: [String: AnyObject]) {
        
        
        let session = URLSession.shared
        let request = URLRequest(url: flickrURLFromParameters(methodParameters))
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                print(error)
                performUIUpdatesOnMain {
                    print("could not get the image")
                }
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = parsedResult[flickrConstant.FlickrResponseKeys.Status] as? String, stat == flickrConstant.FlickrResponseValues.OKStatus else {
                print("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            /* GUARD: Is "photos" key in our result? */
            guard let photosDictionary = parsedResult[flickrConstant.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                displayError("Cannot find keys '\(flickrConstant.FlickrResponseKeys.Photos)' in \(parsedResult)")
                return
            }
            
            print(photosDictionary)
            
            /* GUARD: Is "pages" key in the photosDictionary? */
            guard let totalPages = photosDictionary[flickrConstant.FlickrResponseKeys.Pages] as? Int else {
                displayError("Cannot find key '\(flickrConstant.FlickrResponseKeys.Pages)' in \(photosDictionary)")
                return
            }
        }
        
        // start the task!
        task.resume()
  
}

private func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
    
    var components = URLComponents()
    components.scheme = flickrConstant.Flickr.APIScheme
    components.host = flickrConstant.Flickr.APIHost
    components.path = flickrConstant.Flickr.APIPath
    components.queryItems = [URLQueryItem]()
    
    for (key, value) in parameters {
        let queryItem = URLQueryItem(name: key, value: "\(value)")
        components.queryItems!.append(queryItem)
    }
    
    return components.url!
}
    
    class func sharedInstance() -> flickrClient {
        struct Singleton {
            static var sharedInstance = flickrClient()
        }
        return Singleton.sharedInstance
}
}




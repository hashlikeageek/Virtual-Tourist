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

class imageViewController : UIViewController
{
     var passedCordinates: CLLocationCoordinate2D!
    
    @IBOutlet weak var text: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(passedCordinates)")
        text.text = "Check debugger"    }
    
}

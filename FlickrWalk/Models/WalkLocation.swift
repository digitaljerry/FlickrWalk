//
//  WalkLocation.swift
//  FlickrWalk
//
//  Created by Jernej Zorec on 21/07/2017.
//  Copyright © 2017 Jernej Zorec. All rights reserved.
//

import UIKit

class WalkLocation: NSObject {
    
    var longitude : Double = 0.0
    var latitude : Double = 0.0
    var photoURL : NSURL?

    init(longitude: Double, latitude: Double, photoURL: NSURL?) {
        self.longitude = longitude
        self.latitude = latitude
        self.photoURL = photoURL
    }
    
    convenience init(longitude: Double, latitude: Double) {
        self.init(longitude: longitude, latitude: latitude, photoURL: nil)
    }
    
}

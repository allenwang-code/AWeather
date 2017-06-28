//
//  LocationModel.swift
//  Weather
//
//  Created by 王適緣 on 2017/6/28.
//  Copyright © 2017年 Allen Wang. All rights reserved.
//

import CoreLocation

class LocationModel: NSObject, NSCoding {
    var city: String
    var coordinate: CLLocationCoordinate2D
    
    init(city: String, coordinate: CLLocationCoordinate2D) {
        self.city = city
        self.coordinate = coordinate
        super.init()
    }

    
    required convenience init(coder aDecoder: NSCoder) {
        let city = aDecoder.decodeObject(forKey: "city") as! String
        let latitude = aDecoder.decodeDouble(forKey: "latitude")
        let longitude = aDecoder.decodeDouble(forKey: "longitude")
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.init(city: city, coordinate: coordinate)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(city, forKey: "city")
        aCoder.encode(coordinate.latitude, forKey: "latitude")
        aCoder.encode(coordinate.longitude, forKey: "longitude")
    }
}

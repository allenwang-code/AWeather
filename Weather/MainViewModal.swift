//
//  MainViewModal.swift
//  Weather
//
//  Created by Allen Wang on 2017/6/25.
//  Copyright © 2017年 Allen Wang. All rights reserved.
//

import Foundation
import CoreLocation
class MainViewModal: NSObject{
    
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation(latitude: 7.39, longitude: 51.30)
    
    func askGPS() {
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    
    }
    
    func getData(){
        
    }
}

extension MainViewModal: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        print("locations = \(lat) \(long)")
        currentLocation =  CLLocation(latitude: lat, longitude: long)
        locationManager.stopUpdatingLocation()
        
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(currentLocation, completionHandler: {
            (placemarks, error)-> Void in
            if (error != nil) { return }
            guard let placemarks = placemarks else { return }
            if placemarks.count == 0 { return }
            let placemark = placemarks[0]
            print(placemark.country)
            print(placemark.administrativeArea)
            print(placemark.subAdministrativeArea)
            
            if let city = placemark.addressDictionary?["City"] {
                print(city)
            }
        })
    }
 
}

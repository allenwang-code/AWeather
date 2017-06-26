//
//  MainViewModal.swift
//  Weather
//
//  Created by Allen Wang on 2017/6/25.
//  Copyright © 2017年 Allen Wang. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

protocol MainViewModalProtocol {
    func getDataFinished()
}


class MainViewModal: NSObject{

    let locationManager = CLLocationManager()
    var currentLocation = Constant.LONDON
    
    var country: String?
    var city: String?
    var weathers: [JSON] = [JSON]()

    var handler: MainViewModalProtocol!
    
    init(handler: MainViewModalProtocol) {
        self.handler = handler
    }
    
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
    
    func getWeatherData() {
        if Constant.KEY.isEmpty { getAPIKeyFromPlist() }
        
        let coordinate = currentLocation.coordinate
        let parameters: Parameters = ["lat": coordinate.latitude,
                                      "lon": coordinate.longitude,
                                      "units": Constant.CELSIUS,
                                      "APPID": Constant.KEY]
        

        Alamofire.request(Constant.FORECAST_URL, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let jsonString = response.result.value {
                print("JSON: \(jsonString)") // serialized json response
                let json = JSON(jsonString: jsonString)
                self.country = json["city"]["country"].string ?? "—"
                self.city = json["city"]["name"].string ?? "—"
                self.weathers = json["list"].array!
                //let max = weathers?[0]["temp"]["max"].stringValue
                //let min = weathers?[0]["temp"]["min"].stringValue
                self.handler.getDataFinished()
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
        
        
    }
    
    private func getAPIKeyFromPlist() {
        var keys: NSDictionary?
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        if let dict = keys {
            Constant.KEY = dict["weatherAPI key"] as? String ?? ""
        }
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
        
//        let geo = CLGeocoder()
//        geo.reverseGeocodeLocation(currentLocation, completionHandler: {
//            (placemarks, error)-> Void in
//            if (error != nil) { return }
//            guard let placemarks = placemarks else { return }
//            if placemarks.count == 0 { return }
//            let placemark = placemarks[0]
//            print(placemark.country!)
//            print(placemark.administrativeArea!)
//            print(placemark.subAdministrativeArea!)
//            
//            if let city = placemark.addressDictionary?["City"] {
//                print(city)
//            }
//        })
        getWeatherData()
    }
 
}

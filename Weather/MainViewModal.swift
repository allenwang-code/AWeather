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
import AVFoundation

protocol MainViewModalProtocol {
    func getDataFinished()
}


class MainViewModal: NSObject{

    let locationManager = CLLocationManager()
    var currentLocation = Constant.LONDON

    var country: String?
    var city: String?
    var forecasts:[WeatherModel] = [WeatherModel]()
    var histories:[WeatherModel] = [WeatherModel]()

    var handler: MainViewModalProtocol!
    
    init(handler: MainViewModalProtocol) {
        self.handler = handler
    }
    
    func askGPS() {
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
        let coordinate = currentLocation.coordinate
        let parameters: Parameters = ["lat": coordinate.latitude,
                                      "lon": coordinate.longitude,
                                      "cnt": 10,
                                      "units": Constant.CELSIUS,
                                      "APPID": Constant.WEATHER_API_KEY]
        

        Alamofire.request(Constant.FORECAST_URL, parameters: parameters).responseJSON { response in
            // print("Request: \(String(describing: response.request))")   // original url request
            // print("Response: \(String(describing: response.response))") // http url response
            // print("Result: \(response.result)")                         // response serialization result
            
            if let jsonString = response.result.value {
                let json = JSON(jsonString: jsonString)
                // print("JSON: \(jsonString)")
                
                self.country = json["city"]["country"].string ?? "—"
                self.city = json["city"]["name"].string ?? "—"
                self.parseObject(from: json)
        
                self.handler.getDataFinished()
            } else {
                print("Error")
            }
        }
    }
    
    
    func prepareAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, with: .mixWithOthers)
        } catch {
            print(error)
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    private func parseObject(from json: JSON) {
        forecasts.removeAll()
        
        guard let list = json["list"].array else { return }
        for item in list {
            let icon = item["weather"][0]["icon"].stringValue
            let outline = item["weather"][0]["main"].stringValue
            let maxString = item["temp"]["max"].stringValue
            let minString = item["temp"]["min"].stringValue
            let time = item["dt"].doubleValue
            let max = Int(Float(maxString) ?? 0)
            let min = Int(Float(minString) ?? 0)

            let w = WeatherModel()
            w.outline = outline
            w.icon = icon
            w.maxDegrees = String(max)
            w.minDegrees = String(min)
            w.time = time
            
            forecasts.append(w)
        }
        
    }
    
  }

extension MainViewModal: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        print("locations = \(lat) \(long)")
        currentLocation = CLLocation(latitude: lat, longitude: long)
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

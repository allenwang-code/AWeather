//
//  MainViewModel.swift
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

protocol MainViewModelProtocol {
    func getDailyDataFinished()
    func getHourlyDataFinished()
}


class MainViewModel: NSObject{

    let locationManager = CLLocationManager()
    var currentLocation = Constant.LONDON

    var country: String?
    var city: String?
    var forecasts:[WeatherModel] = [WeatherModel]()
    var curWeather:[WeatherModel] = [WeatherModel]()
    var histories:[WeatherModel] = [WeatherModel]()

    var handler: MainViewModelProtocol!
    
    init(handler: MainViewModelProtocol) {
        self.handler = handler
        super.init()
        NotificationCenter.default.addObserver(self,
                    selector: #selector(MainViewModel.calledFromHisotry(_:)),
                    name: Notification.Name("pressedHistory"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self, name: Notification.Name("pressedHistory"), object: nil)
    }
    
    func askGPS() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func calledFromHisotry(_ notification: NSNotification) {
        if let coordinate = notification.userInfo?["coordinate"]  {
            let c = coordinate as? CLLocationCoordinate2D
            self.currentLocation = CLLocation(latitude: c!.latitude, longitude: c!.longitude)
        }
        getWeatherData()
    }
    
    func getWeatherData() {
        let coordinate = currentLocation.coordinate
        var parameters: Parameters = ["lat": coordinate.latitude,
                                      "lon": coordinate.longitude,
                                      "cnt": 10,
                                      "units": Constant.CELSIUS,
                                      "APPID": Constant.WEATHER_API_KEY]
        Alamofire.request(Constant.FORECAST_URL, parameters: parameters).responseJSON { response in
                if let jsonString = response.result.value {
                let json = JSON(jsonString: jsonString)
                
                self.country = json["city"]["country"].string ?? "—"
                self.city = json["city"]["name"].string ?? "—"
                self.parseDailyData(from: json, to: &self.forecasts)
                    
                self.storeUserAction()
                self.handler.getDailyDataFinished()
            } else {
                print("Error")
            }
        }
        
        parameters = ["lat": coordinate.latitude,
                      "lon": coordinate.longitude,
                      "cnt": 10,
                      "units": Constant.CELSIUS,
                      "APPID": Constant.WEATHER_API_KEY]
        Alamofire.request(Constant.CURRENT_WEATHER_URL, parameters: parameters).responseJSON { response in
            
            if let jsonString = response.result.value {
                let json = JSON(jsonString: jsonString)
                self.country = json["city"]["country"].string ?? "—"
                self.city = json["city"]["name"].string ?? "—"
                self.parseHourlyData(from: json, to: &self.curWeather)
                self.handler.getHourlyDataFinished()
            } else {
                print("Error")
            }
        }
    }
    
    
    func prepareAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, with: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    private func storeUserAction(){
        let ud = UserDefaults.standard

        let decoded  = ud.object(forKey: Constant.USER_CREATION) as? Data
        var encodedData: Data!
        if decoded != nil {
            var locations = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [LocationModel]
            for location in locations {
                if location.city == self.city { return }
                locations.append(LocationModel(city: self.city!,coordinate: self.currentLocation.coordinate))
            }
            encodedData = NSKeyedArchiver.archivedData(withRootObject: locations)
        } else {
            let ls = [LocationModel(city: self.city!, coordinate: self.currentLocation.coordinate)]
            encodedData = NSKeyedArchiver.archivedData(withRootObject: ls)
        }
        ud.set(encodedData, forKey: Constant.USER_CREATION)
        ud.synchronize()
    }
    
    private func parseDailyData(from json: JSON, to array: inout [WeatherModel]) {
        array.removeAll()
        
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
            
            array.append(w)
        }
    }
    
    private func parseHourlyData(from json: JSON, to array: inout [WeatherModel]) {
        array.removeAll()
        
        guard let list = json["list"].array else { return }
        for item in list {
            let time = item["dt"].doubleValue
            let icon = item["weather"][0]["icon"].stringValue
            let outline = item["weather"][0]["main"].stringValue
            let maxString = item["main"]["temp_max"].stringValue
            let minString = item["main"]["temp_min"].stringValue
            let max = Int(Float(maxString) ?? 0)
            let min = Int(Float(minString) ?? 0)
            
            let w = WeatherModel()
            w.outline = outline
            w.icon = icon
            w.maxDegrees = String(max)
            w.minDegrees = String(min)
            w.time = time
            
            array.append(w)
        }
    }
  }

extension MainViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        print("locations = \(lat) \(long)")
        currentLocation = CLLocation(latitude: lat, longitude: long)
        locationManager.stopUpdatingLocation()
        
        getWeatherData()
    }
 
}

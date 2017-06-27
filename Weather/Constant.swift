//
//  Constant.swift
//  Weather
//
//  Created by 王適緣 on 2017/6/26.
//  Copyright © 2017年 Allen Wang. All rights reserved.
//

/**
 Examples of API calls:
 Call 10 days forecast by geographic coordinates
 api.openweathermap.org/data/2.5/forecast/daily?lat=35&lon=139&cnt=10&APPID=11111111
 
 Call current weather  by geographic coordinates
 api.openweathermap.org/data/2.5/weather?lat=35&lon=139&APPID=11111111
 
 **/

import CoreLocation

class Constant {
    public static let LONDON = CLLocation(latitude: 51.509865, longitude: -0.118092)
    public static let FORECAST_URL = "http://api.openweathermap.org/data/\(VERSION)/forecast/daily"
    public static let CELSIUS = "metric"
    private static let VERSION = "2.5"
    
    // get these from plist when app start
    public static var WEATHER_API_KEY = ""
    public static var MAP_API_KEY = ""
   }



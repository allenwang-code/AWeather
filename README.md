# AWeather

A weather app developed in Swift3.

## App Screen

![Imgur](http://i.imgur.com/UDWQVMD.gifv)

## How to build

1) Clone the repository

```bash
$ git clone https://github.com/q1q1w1w1q/AWeather.git
```

2) Install pods

```bash
$ cd AWeather
$ pod install
```

3) Open the workspace in Xcode

```bash
$ open "AWeather.xcworkspace"
```

4) Sign up on [openweathermap.org/appid](http://openweathermap.org/appid) to get an appid

5) Sign up on [GoogleMAPAPI/mapKey](https://developers.google.com/maps/documentation/ios-sdk/get-api-key) to get an appid

6) create .plist file named Keys.plist like below in ../AWeather/Weather/
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>weatherAPI key</key>
	<string>YOUR WEATHER KEY</string>
	<key>GoogleMap key</key>
	<string>YOUR MAP KEY</string>
</dict>
</plist>
```
*Please replace "YOUR KEY" with your actual appid key.*
 
5) Compile and run the app in your simulator

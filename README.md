# AWeather

A weather app developed in Swift3.

## App Screen

<img src='http://i.imgur.com/azU7t88.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

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

5) Sign up on [GoogleMAPAPI/mapKey](https://developers.google.com/maps/documentation/ios-sdk/get-api-key) to get an api key

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

## Open-source libraries used

- [Alamofire]
- [SwiftyJSON]
- [Kingfisher]
- [gson]
- [PKHUD]
- [GoogleMaps SDK]

## License

    Copyright AllenWang

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.


//
//  Utility.swift
//  Weather
//
//  Created by Allen Wang on 2017/6/24.
//  Copyright © 2017年 Allen Wang. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class Util {
    
    public static func tranfer(_ time: Double, to format: String = "MMM dd") -> String {
        let date = NSDate(timeIntervalSince1970: time)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = format
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    public static func popUpDialog(vc:UIViewController, on btn:UIButton, title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        alert.popoverPresentationController?.sourceView = btn
        alert.popoverPresentationController?.sourceRect = btn.bounds
        vc.present(alert, animated: true, completion: nil)
    }
    
    public static func getScreenShot() -> UIImage? {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)

        return screenshot
    }
    
    public static func shareToSocailMedia(from vc:UIViewController, on btn:UIButton,
                                          with image:UIImage, and text: String = "") {
        let message = text.isEmpty ? "Shared by Aweather." : text
        // let link = NSURL(string: "http://yo.com")
        
        let objectsToShare = [message, image] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = btn
        activityVC.popoverPresentationController?.sourceRect = btn.bounds

        vc.present(activityVC, animated: true, completion: nil)
    }

    public static func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
}

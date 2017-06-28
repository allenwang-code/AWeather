//
//  Utility.swift
//  Weather
//
//  Created by Allen Wang on 2017/6/24.
//  Copyright © 2017年 Allen Wang. All rights reserved.
//

import Foundation
import UIKit
class Util {
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

    
}

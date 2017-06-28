//
//  HierarchyCollectionDelegate.swift
//  Weather
//
//  Created by 王適緣 on 2017/6/28.
//  Copyright © 2017年 Allen Wang. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class HierarchyCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var weathers = [WeatherModel]()
    var city = ""
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tappedCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! MainCollectionViewCell
        
        let w = weathers[indexPath.item]
        let url = URL(string: Constant.WEATHER_IMAGE_URL + w.icon + ".png")
        
        cell.ivWeather.kf.setImage(with: url)
        cell.lbDegrees.text = "\(w.minDegrees) ~\(w.maxDegrees)°C"
        cell.lbDate.text = Util.tranfer(w.time!)
        return cell
    }
    
    private func tappedCell(at indexPath: IndexPath) {
        let w = weathers[indexPath.item]
        let date = Util.tranfer(w.time!)
        let c = city.isEmpty ? "" : "in \(city)"
        let utterrance = AVSpeechUtterance(string: "\(date) \(c) is forecasted" +
            "to be \(w.minDegrees) degrees to \(w.minDegrees) degrees and \(w.outline)")
        utterrance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterrance)
    }
}

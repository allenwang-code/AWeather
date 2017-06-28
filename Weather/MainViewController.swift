//
//  MainViewController.swift
//  Weather
//
//  Created by Allen Wang on 2017/6/24.
//  Copyright © 2017年 Allen Wang. All rights reserved.
//

import UIKit
import AVFoundation
import Kingfisher
import GooglePlacePicker
import PKHUD

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flow: UICollectionViewFlowLayout!
    
    @IBOutlet weak var ivWeather: UIImageView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var lbDegree: UILabel!
    
    var viewModel: MainViewModal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainViewModal(handler: self)
        viewModel.prepareAudioSession()
        viewModel.askGPS()
        viewModel.getWeatherData()

        setUpCollctionViewCell()
        setUpNavigationBar()        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userHistory(from btn: UIButton) {
        let history = HistoryViewController()
        history.popoverPresentationController?.sourceView = btn
        history.popoverPresentationController?.sourceRect = btn.bounds
        self.present(history, animated: true, completion: nil)
    }

    func pickPlaceFromMap(from btn: UIButton) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        placePicker.modalPresentationStyle = .popover
        placePicker.popoverPresentationController?.sourceView = btn
        placePicker.popoverPresentationController?.sourceRect = btn.bounds
        self.present(placePicker, animated: true, completion: nil)
    }
    
    func shareToNetwork(from btn: UIButton) {
        if let image = Util.getScreenShot() {
            Util.shareToSocailMedia(from: self, on: btn, with: image)
        } else {
            let title = NSLocalizedString("Oops", comment: "")
            let msg = NSLocalizedString("Unable to share now, please retry later", comment: "")
            Util.popUpDialog(vc: self, on: btn, title: title, message: msg)
        }
    }
    
    private func setUpCollctionViewCell() {
        let cell = UINib(nibName: "MainColletionViewCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: "mainCell")
    }
 
    private func setUpNavigationBar() {
        self.title = NSLocalizedString("AWeather", comment: "")
        self.navigationController?.isNavigationBarHidden = false
        
        let location = UIButton.init(type: .custom)
        location.setImage(#imageLiteral(resourceName: "current location"), for: UIControlState.normal)
        location.addTarget(viewModel, action:#selector(MainViewModal.askGPS), for: .touchUpInside)
        location.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let locationItem = UIBarButtonItem.init(customView: location)
        
        let map = UIButton()
        map.setImage(#imageLiteral(resourceName: "map-1"), for: UIControlState.normal)
        map.addTarget(self, action:#selector(pickPlaceFromMap(from:)), for: .touchUpInside)
        map.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let mapItem = UIBarButtonItem.init(customView: map)
        
        let share = UIButton()
        share.setImage(#imageLiteral(resourceName: "share"), for: UIControlState.normal)
        share.addTarget(self, action:#selector(shareToNetwork(from:)), for: .touchUpInside)
        share.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let shareItem = UIBarButtonItem.init(customView: share)

        let rightButtons = [shareItem, mapItem, locationItem]
        self.navigationItem.setRightBarButtonItems(rightButtons, animated: true)
        
        let history = UIButton()
        history.setImage(#imageLiteral(resourceName: "history"), for: UIControlState.normal)
        history.addTarget(self, action:#selector(userHistory(from:)), for: .touchUpInside)
        history.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let historyItem = UIBarButtonItem.init(customView: history)

        // self.navigationItem.leftBarButtonItem = historyItem
        self.navigationItem.setLeftBarButton(historyItem, animated: true)
    }
}


extension MainViewController: UICollectionViewDataSource,
    UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tappedCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! MainCollectionViewCell

            let w = viewModel.weathers[indexPath.item]
            let icon = w["weather"][0]["icon"].stringValue
            let maxString = w["temp"]["max"].stringValue
            let minString = w["temp"]["min"].stringValue
            let max = Int(Float(maxString)!)
            let min = Int(Float(minString)!)
            let url = URL(string: Constant.WEATHER_IMAGE_URL + icon + ".png")
            cell.ivWeather.kf.setImage(with: url)
            cell.lbDegrees.text = "\(String(describing: min)) ~\(String(describing: max))°C"
            
            let date = NSDate(timeIntervalSince1970: w["dt"].doubleValue)
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM dd"
            let dateString = dayTimePeriodFormatter.string(from: date as Date)
            cell.lbDate.text = dateString
            return cell
    }
    
    private func tappedCell(at indexPath: IndexPath) {
        let w = viewModel.weathers[indexPath.item]
        let icon = w["weather"][0]["icon"].stringValue
        let maxString = w["temp"]["max"].stringValue
        let minString = w["temp"]["min"].stringValue
        let date = NSDate(timeIntervalSince1970: w["dt"].doubleValue)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)

        let outline = w["weather"][0]["main"].stringValue
        
        let utterrance = AVSpeechUtterance(string: "\(dateString) in \(viewModel.city!) is forecasted" +
            "to be \(minString) degrees to \(maxString) degrees and \(outline)")
        utterrance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterrance)
    }
}

extension MainViewController : GMSPlacePickerViewControllerDelegate {
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        let c = place.coordinate
        print(c)
        viewModel.currentLocation = CLLocation(latitude: c.latitude, longitude: c.longitude)
        viewModel.getWeatherData()
        
        // Dismiss the place picker.
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        NSLog("An error occurred while picking a place: \(error)")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        NSLog("The place picker was canceled by the user")
        // Dismiss the place picker.
        viewController.dismiss(animated: true, completion: nil)
    }
}


extension MainViewController: MainViewModalProtocol{
    func getDataFinished() {
   
        HUD.flash(.progress, delay: 1.0)

        let todayWeather = viewModel.weathers[0]
        
        
        let date = NSDate(timeIntervalSince1970: todayWeather["dt"].doubleValue)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        lbDate.text = dateString
        lbCity.text = viewModel.country! + ", " + viewModel.city!
    
        let maxString = todayWeather["temp"]["max"].stringValue
        let minString = todayWeather["temp"]["min"].stringValue
        let max = Int(Float(maxString)!)
        let min = Int(Float(minString)!)
        lbDegree.text = "\(String(describing: min)) ~\(String(describing: max))°C"
        
        let icon = todayWeather["weather"][0]["icon"].stringValue
        let url = URL(string: Constant.WEATHER_IMAGE_URL + icon + ".png")
        ivWeather.kf.setImage(with: url)

        collectionView.reloadData()

    }
    
    
}

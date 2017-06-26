//
//  MainViewController.swift
//  Weather
//
//  Created by Allen Wang on 2017/6/24.
//  Copyright © 2017年 Allen Wang. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flow: UICollectionViewFlowLayout!
    
    var viewModel: MainViewModal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        viewModel = MainViewModal()
        viewModel.getData()
        viewModel.askGPS()
        
        setUpCollctionViewCell()
        setUpNavigationBar()
      
        getWeatherData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        map.addTarget(self, action:#selector(goto), for: .touchUpInside)
        map.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let mapItem = UIBarButtonItem.init(customView: map)
        
        let share = UIButton()
        share.setImage(#imageLiteral(resourceName: "share"), for: UIControlState.normal)
        share.addTarget(self, action:#selector(shareToNetwork), for: .touchUpInside)
        share.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let shareItem = UIBarButtonItem.init(customView: share)
        

        let buttonArray = [shareItem, mapItem, locationItem]
        self.navigationItem.setRightBarButtonItems(buttonArray, animated: true)
    }
 
    func goto() {
    
    }
    
    func shareToNetwork() {
    
    }
    
    private func getWeatherData() {
        if Constant.KEY.isEmpty { getAPIKeyFromPlist() }
    
        let coordinate = viewModel.currentLocation.coordinate
        let parameters: Parameters = ["lat": coordinate.latitude,
                                      "lon": coordinate.longitude,
                                      "APPID": Constant.KEY]

        
        Alamofire.request(Constant.FORECAST_URL, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
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


extension MainViewController: UICollectionViewDataSource,
    UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "mainCell", for: indexPath)
            
//            let screenSize = UIScreen.main.bounds
            //let screenWidth = screenSize.width
            //let screenHeight = screenSize.height
            
            cell.frame.size.width = 125
            cell.frame.size.height = 165
        
//            // 設置 cell 內容 (即自定義元件裡 增加的圖片與文字元件)
//            cell.imageView.image = 
//                UIImage(named: "0\(indexPath.item + 1).jpg")
//            cell.titleLabel.text = "0\(indexPath.item + 1)"
            
            return cell
    }
    
}

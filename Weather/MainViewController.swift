//
//  MainViewController.swift
//  Weather
//
//  Created by Allen Wang on 2017/6/24.
//  Copyright © 2017年 Allen Wang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flow: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cell = UINib(nibName: "MainColletionViewCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: "mainCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            cell.frame.size.width = 250
            cell.frame.size.height = 100
        
//            // 設置 cell 內容 (即自定義元件裡 增加的圖片與文字元件)
//            cell.imageView.image = 
//                UIImage(named: "0\(indexPath.item + 1).jpg")
//            cell.titleLabel.text = "0\(indexPath.item + 1)"
            
            return cell
    }
    
}

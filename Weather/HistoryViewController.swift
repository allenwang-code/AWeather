//
//  HistoryViewController.swift
//  Weather
//
//  Created by Allen Wang on 2017/6/28.
//  Copyright © 2017年 Allen Wang. All rights reserved.
//

import UIKit
import CoreLocation

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var histories: [Int:[String:CLLocationCoordinate2D]] = [0:["Taiwan":CLLocationCoordinate2D(latitude:123, longitude:23)]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return histories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            as UITableViewCell
        cell.textLabel?.text = histories[indexPath.item]?.keys.first
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }

}

//
//  BookTickerViewController.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import UIKit
class BookTickerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var arrWeather: [ForeCastDay] = []
    var name: String?
    @IBOutlet weak var labelWeatherTittle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather"
    labelWeatherTittle.text = "Weather next 7 day in \(name ?? "")"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWeather.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        cell.dayWeather.text = String(arrWeather[indexPath.row].date_epoch.dayWeek(identifier: "VI"))
        cell.tempcMax.text = "Days: " + String(arrWeather[indexPath.row].maxtemp_c) + "°"
        cell.tempcMin.text = "Night: " + String(arrWeather[indexPath.row].mintemp_c) + "°"
        cell.imageWather.download(from: arrWeather[indexPath.row].icon)
        
        return cell
    }

}

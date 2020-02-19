//
//  WeatherTableViewCell.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var dayWeather: UILabel!
    @IBOutlet weak var imageWather: UIImageView!
    @IBOutlet weak var tempcMax: UILabel!
    @IBOutlet weak var tempcMin: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

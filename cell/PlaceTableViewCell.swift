//
//  PlaceTableViewCell.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var imageN: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageN.layer.cornerRadius = imageN.frame.height/2
        imageN.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

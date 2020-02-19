//
//  HomeTableViewCell.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewNew: UIImageView!
    @IBOutlet weak var nameLAbel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewNew.layer.cornerRadius = imageViewNew.frame.height/2
        imageViewNew.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

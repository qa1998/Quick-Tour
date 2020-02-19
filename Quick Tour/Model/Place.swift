//
//  PlacesVietnam.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import Foundation
class Place {
    var name: String
    var image: String
    var content: String
    init(dict: DICT) {
        name = dict["name"] as? String ?? "-1"
        image = dict["image"] as? String ?? "-1"
        content = dict["content"] as? String ?? "-1"
    }
}

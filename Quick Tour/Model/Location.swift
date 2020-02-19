//
//  Location.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import Foundation
class Location{
    var Name: String?
    var id: String?
    var description: String?
    var rating: Int?
    var image: String?
    var comment: DICT?
    var district: String?
    
    init(name: String ,dict: DICT) {
        let id = dict["id"] as? String ?? ""
        let description = dict["Description"] as? String ?? ""
        let image = dict["image"] as? String ?? ""
        let rating = dict["Rating"] as? Int ?? 0
        let comment = dict["Comment"] as? DICT ?? [:]
        let district = dict["district"] as? String ?? ""
        
        self.district = district
        self.comment = comment
        self.id = id
        self.Name = name
        self.description = description
        self.rating = rating
        self.image = image
        
        
    }
}

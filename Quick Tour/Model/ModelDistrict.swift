//
//  ModelFireBase.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import Foundation

class ModelDistrict{
    var name: String?
    var bookingHotel: String?
    var checkLike: String?
    var description: String?
    var rating: Int?
    var thumnailsImage: String?
    var image: [String] = []
    var location: DICT?
    
    init(name: String , dict: DICT) {
        let bookingHotel = dict["Booking Hotel"] as? String ?? ""
        let checkLike = dict["Check Like"] as? String ?? ""
        let description = dict["Description"] as? String ?? ""
        let thumnailsImage = dict["ThumnailsImage"] as? String ?? ""
        let rating = dict["Rating"] as? Int ?? 0
        let location = dict["Location"] as? DICT ?? [:]
        let URLimage = dict["URL image"] as? [DICT] ?? [[:]]
       
        self.location = location
        self.name = name
        self.bookingHotel = bookingHotel
        self.checkLike = checkLike
        self.description = description
        self.rating = rating
        self.thumnailsImage = thumnailsImage
        
        
    }
}


//
//  TimeIntervel.swift
//  AppWeather7Days
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import Foundation
extension TimeInterval{
    func dayWeek(identifier: String) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: identifier)
        return dateFormatter.string(from: date)
    }
    
    var intTimeCurrent: Int {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh"
            let timeZone = TimeZone(identifier: "Asia/Hanoi")
            dateFormatter.timeZone = timeZone
            let stringTimeCurrent = dateFormatter.string(from: Date())
            return Int(stringTimeCurrent)!
        }
    }
}

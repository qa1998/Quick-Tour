//
//  Weather.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import Foundation
typealias DICT = Dictionary<AnyHashable, Any>
class Weather {
    var forecastDays: [ForeCastDay] = []    
    init(dict: DICT) {
        let forecast = dict["forecast"] as? DICT ?? [:]
        print(forecast)
        let forecastday = forecast["forecastday"] as? [DICT] ?? []
        print(forecastday)
        for data in forecastday {
            forecastDays.append(ForeCastDay(dict: data))
        }
    }
}

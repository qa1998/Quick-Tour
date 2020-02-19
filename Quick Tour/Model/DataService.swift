//
//  DataService.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import UIKit

class DataService {
    static let shared: DataService = DataService()

    
    class func apiWeather(url: String,complete: @escaping(Weather)-> Void){
        let urlString = url
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else {return}
            guard let aData = data else {return}
            do{
                guard let reSult = try JSONSerialization.jsonObject(with: aData, options: .mutableContainers) as? DICT else {return}
                DispatchQueue.main.async {
                    complete(Weather(dict: reSult))
                }
                
            }
            catch{
                print(error.localizedDescription)
            }
            }.resume()
    }
    
}

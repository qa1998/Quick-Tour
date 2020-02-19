//
//  Common.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import Foundation
import UIKit

func showAlert(message: String, title: String,vc: UIViewController){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(okAction)
    vc.present(alert, animated: true, completion: nil)
}

//
//  CustomView.swift
//  Quick Tour
//
//  Created by Nguyễn Đức Dũng on 3/12/19.
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import UIKit
//@IBDesignable
class CustomView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}

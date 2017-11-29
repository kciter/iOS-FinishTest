//
//  DesignableImageView.swift
//  FoodList
//
//  Created by 이선협 on 2017. 11. 29..
//  Copyright © 2017년 이선협. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}

//
//  LoadingImages.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/8/2.
//

import Foundation
import UIKit

class LoadingImages: UIImageView {
    func rotate() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.toValue = -Double.pi * 2
        rotateAnimation.duration = 5
        rotateAnimation.speed = 3.5
        rotateAnimation.repeatCount = .infinity
        layer.add(rotateAnimation, forKey: nil)
    }
    
}

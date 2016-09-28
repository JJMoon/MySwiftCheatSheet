//
//  HtCheckBoxButton.swift
//  Test
//
//  Created by Jongwoo Moon on 2016. 1. 25..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation
import UIKit

class HtCheckBoxButton: UIButton {

    var checked = false

    convenience init(x: CGFloat, y: CGFloat, size: CGFloat, state: Bool) {
        self.init(frame: CGRect(x: x, y: y, width: size, height: size))
        checked = state
        setBgImage()
    }

    func initSet(x: CGFloat, y: CGFloat, size: CGFloat, state: Bool) {
        self.frame = CGRect(x: x, y: y, width: size, height: size)

    }

    func checkToggle() {
        checked = !checked
        setBgImage()
    }

    private func setBgImage() {
        if checked {
            setBackgroundImage(UIImage(named: "btn_check"), forState: .Normal)
        } else {
            setBackgroundImage(UIImage(named: "btn_uncheck"), forState: .Normal)
        }
    }
}


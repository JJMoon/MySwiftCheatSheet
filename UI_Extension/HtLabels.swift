//
//  HtLabels.swift
//  Test
//
//  Created by Jongwoo Moon on 2016. 1. 25..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation
import UIKit

class HtUltraLightLabel : UILabel {


    convenience init(x: CGFloat, y: CGFloat, wid: CGFloat, hgh: CGFloat, size: CGFloat, txt: String) {
        self.init(frame: CGRect(x: x, y: y, width: wid, height: hgh))
        font =  UIFont (name: "HelveticaNeue-UltraLight", size: size)
        text = txt
        sizeToFit()
        frame.origin.y = y + (hgh - frame.height) / 2
    }

}
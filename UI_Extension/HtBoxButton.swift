//
//  HtBoxButton.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2016. 1. 3..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation
import UIKit

class HtBoxButton : UIButton {
    func setCornerRadius(rad : CGFloat) {
        layer.cornerRadius = rad
    }

    func setTitleAndBackground(bgColor: UIColor, ttlStr: String) {
        setTitle(ttlStr, forState: .Normal)
        backgroundColor = bgColor
    }

    func makeNormalText(bgColor: UIColor?, txtCol: UIColor?) {
        if (bgColor == nil) { backgroundColor = UIColor.whiteColor() }
        else { backgroundColor = bgColor }
        if (txtCol == nil) { setTextColor(UIColor.blackColor()) }
        else { setTextColor(txtCol!) }
    }

    func makeGrayBox(rad: CGFloat) {
        backgroundColor = UIColor.grayColor()
        setCornerRadius(rad)
    }

    func setTextColor(col: UIColor) {
        self.setTitleColor(col, forState: UIControlState.Normal)
    }


}

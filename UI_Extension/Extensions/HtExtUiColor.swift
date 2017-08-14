//
//  HtExtUiColor.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2016. 1. 12..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    convenience init(red: Int, green255: Int, blue255: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green255 >= 0 && green255 <= 255, "Invalid green component")
        assert(blue255 >= 0 && blue255 <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green255) / 255.0, blue: CGFloat(blue255) / 255.0, alpha: 1.0)
    }

    convenience init(red255: Int, green255: Int, blue255: Int, alpha: CGFloat) {
        assert(red255 >= 0 && red255 <= 255, "Invalid red component")
        assert(green255 >= 0 && green255 <= 255, "Invalid green component")
        assert(blue255 >= 0 && blue255 <= 255, "Invalid blue component")
        assert(0 <= alpha && alpha <= 1.0, "Invalid alpha value")

        self.init(red: CGFloat(red255) / 255.0, green: CGFloat(green255) / 255.0, blue: CGFloat(blue255) / 255.0, alpha: 1.0)
    }

    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green255:(netHex >> 8) & 0xff, blue255:netHex & 0xff)
    }

//    convenience init(hex:String) {
//        let cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
//
//        //if (cString.hasPrefix("#")) {
//          //  cString = cString.substringFromIndex(advance(cString.startIndex, 1))        }
//
//        if ((cString.characters.count) != 6) {
//            self.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
//            return
//        }
//
//        var rgbValue:UInt32 = 0
//        NSScanner(string: cString).scanHexInt(&rgbValue)
//
//        self.init(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
//    }

}


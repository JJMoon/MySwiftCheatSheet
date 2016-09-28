//
//  HtDouble.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2016. 1. 8..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation
import UIKit


extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }

    func vectSum(y: Double, z: Double) -> Double {
        return sqrt( pow(self, 2) + pow(y, 2) + pow(z, 2) )
    }

    func isEqualTo(v: Double, thld: Double) -> Bool {
        return fabs(self - v) < fabs(thld)
    }

    // println("The floating point number \(someDouble) formatted with " looks like \(someDouble.format(.3))")
    // The floating point number 3.14159265359 formatted with ".3" looks like 3.142
}

extension Int {
    ///  val = val.betweenValueOf(23, high: 45)
    func betweenValueOf(low: Int, high: Int) -> Int { // 범위를 벗어날 때 제한 값을 리턴..
        if self < low { return low }
        if high < self { return high }
        return self
    }

}

extension CGPoint {
    func offset(diffx: CGFloat, diffy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + diffx, y: self.y + diffy)
    }
}

extension CGSize {
    func offset(wid: CGFloat, hei: CGFloat) -> CGSize {
        return CGSize(width: self.width + wid, height: self.height + hei)
    }
}
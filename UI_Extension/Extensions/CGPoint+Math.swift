//
//  CGPoint+Math.swift
//  Tongtong
//
//  Created by Jongwoo Moon on 2016. 9. 9..
//  Copyright © 2016년 IMLabInc. All rights reserved.
//

import Foundation
import UIKit

public extension CGPoint {

    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }


    func vectorTo(tar: CGPoint) -> CGPoint {
        return CGPoint(x: tar.x - self.x, y: tar.y - self.y)
    }

    func distanceFrom(po: CGPoint) -> CGFloat {
        return vectorTo(tar: po).length()
    }
}

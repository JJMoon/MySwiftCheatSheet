//
//  HtExtNSObject.swift
//  Test
//
//  Created by Jongwoo Moon on 2016. 3. 11..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation
import UIKit

public extension NSObject {

    func colorGreenRedBy(pbool: Bool) -> UIColor {
        if (pbool) { return colorOKGreen }
        return colorNtGdRed
    }

}
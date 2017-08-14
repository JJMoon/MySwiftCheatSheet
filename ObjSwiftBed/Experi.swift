//
//  Experi.swift
//  ObjSwiftBed
//
//  Created by JJTTMOON on 2017. 7. 25..
//  Copyright © 2017년 JJTTMOON. All rights reserved.
//

import Foundation


class Experi: NSObject {
    
    var arr = Array<Int>()
    
    func arrayTest() {
        arr = [3, 4, 5, 7]
        arr += [8, 5, 8]
        
        let is3 = arr.indexOfFirst(object: 8)
        
        print("  arr : \(arr)  8 > \(is3!)")
    }
    
    
    
}

//
//  HtExtString.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2015. 11. 17..
//  Copyright © 2015년 IMLab. All rights reserved.
//

import Foundation


//////////////////////////////////////////////////////////////////////     _//////////_     [     ]    _//////////_   Go to Main View
// MARK:  Extension


extension String {
    func positionOf(sub:String)->Int {
        var pos = -1
        if let range = self.rangeOfString(sub) {
            if !range.isEmpty {
                pos = self.startIndex.distanceTo(range.startIndex)
            }
        }
        return pos
    }
    
    func getLength() -> Int {
        return self.lengthOfBytesUsingEncoding(NSASCIIStringEncoding)
    }

    func getLengthUTF32() -> Int {
        return self.lengthOfBytesUsingEncoding(NSUTF32BigEndianStringEncoding)
    }

    func subStringFrom(pos:Int)->String {
        var substr = ""
        let start = self.startIndex.advancedBy(pos)
        let end = self.endIndex
        //		println("String: \(self), start:\(start), end: \(end)")
        let range = start..<end
        substr = self[range]
        //		println("Substring: \(substr)")
        return substr
    } // print(" string extention test ::  ss  \(ss)  \(ss.removeLast(1))   to5  \(ss.subStringTo(5)) ")

    /// 끝의 글자 삭제..
    func removeLast(num: Int) -> String {
        let len = self.getLength()
        if len < num { return self }
        return self.subStringTo(len - num)
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }

    /// 처음부터 남길 글자 갯수가 인수임.. 12345 to 3 => 123
    func subStringTo(pos:Int) -> String {
        var substr = ""
        let end = self.startIndex.advancedBy(pos-1)
        let range = self.startIndex...end
        substr = self[range]
        return substr
    }
    
    func urlEncoded()->String {
        let res:NSString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, self as NSString, nil,
            "!*'();:@&=+$,/?%#[]", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))
        return res as String
    }
    
    func urlDecoded()->String {
        let res:NSString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, self as NSString, "", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))
        return res as String
    }
    
    func range()->Range<String.Index> {
        return Range<String.Index>(start:startIndex, end:endIndex)
    }

    func comparePassword(pass2: String, minLen: Int) -> Bool {
        return minLen <= self.getLength() && self == pass2
    }
}
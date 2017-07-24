//
//  HtExtArrayGetPrevNext.swift
//  HS Monitor
//
//  Created by Jongwoo Moon on 2016. 7. 26..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation


extension Array {


    func indexOfFirst<Element: Equatable>(object: Element) -> Int? {
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? Element {
                if object == to {
                    return idx
                }
            }
        }
        return nil
    }

    func getNext<Element: Equatable>(obj: Element) -> ArraySlice<Element> {
        //var rArr = [Element]()
        if let idx = self.indexOfFirst(object: obj) {

            print(" next  idx >>  \(idx)  \(self.startIndex)   \(self.count)")
            if idx == self.endIndex - 1 {
                return []
            }
//            for k in idx + 1..<self.endIndex {
//                rArr.append(self[k] as! Element)
//            }
            return self[(idx + 1)..<self.endIndex] as! ArraySlice<Element>
        }
        return []
    }


    func getPrev<Element: Equatable>(obj: Element) -> [Element] {
        //var rArr = [Element]()
        if let idx = self.indexOfFirst(object: obj) {
            if idx == 0 {
                return []
            }
            return self[0..<idx] as! [Element]
        }
        return []
    }

    func getNextMatch<Element: Equatable>(obj: Element, filter: (Element)-> Bool ) -> Element? {
        let nextArr = getNext(obj: obj)
        for ob in nextArr {
            if filter(ob) { return ob as? Element }
        }
        return nil
    }

    func getPrevMatch<Element: Equatable>(obj: Element, filter: (Element)-> Bool ) -> Element? {
        var prevArr = getPrev(obj: obj)
        prevArr = prevArr.reversed()
        for ob in prevArr {
            if filter(ob) { return ob as? Element }
        }
        return nil
    }

}

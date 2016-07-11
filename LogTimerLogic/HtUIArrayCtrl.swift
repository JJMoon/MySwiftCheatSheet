//
//  HtUIArrayCtrl.swift
//  Test
//
//  Created by Jongwoo Moon on 2016. 3. 16..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation


class HtUIElement: HtObject {
    var confirm = false
    var student: HmStudent?

    override init() {
        super.init()
        log.clsName = "HtUIElement"
    }

    convenience init(std: HmStudent?) {
        self.init()
        student = std
    }

    func confirmThis() {
        confirm = true
    }

    func printMyName() {
        print("\t   HtUIElement :: \(student?.name)  \t   confirm > \(confirm)  ")
    }
}

class HsUIArray: HtObject {

    var arrEle = [HtUIElement]()
    var allConfirmed : Bool { get {
        for ele in arrEle {
            if ele.student != nil && ele.confirm == false {
                return false
            }
        }
        return true
        }}

    override init() {
        super.init()
        log.clsName = "HsUIArray"
    }

    func addUIElementWith(std: HmStudent?) {
        arrEle.append(HtUIElement(std: std))
    }

    func isConfirmedOf(std: HmStudent?) -> Bool {
        if std == nil { return true } // 학생이 없으면 그냥 저장 된걸로 해야 함...
        let theArr = arrEle.filter { (ele) -> Bool in
            return ele.student == std
        }
        if theArr.count == 0 { return false } // 에러 케이스
        print(" isConfirmedOf student :: filtered obj >> \(theArr.count) == 1 이어야 함..")
        return theArr.first!.confirm
    }

    func confirmOfStudent(student: HmStudent?) {
        if student == nil { return }
        for ele in arrEle {
            if ele.student == student {
                log.printAlways("  confirm for this student :: \(ele.student?.name)")
                ele.confirmThis()
            }
        }
    }

    func printAll() {
        print("HtUIArrayCtrl.swift >> HsUIArray :: printAll   arrEle.count : \(arrEle.count)")
        for ele in arrEle {
            ele.printMyName()
        }
    }

}
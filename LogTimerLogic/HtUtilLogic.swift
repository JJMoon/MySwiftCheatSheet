//
//  HtUtilLogic.swift
//  heartisense
//
//  Created by Jongwoo Moon on 2015. 10. 27..
//  Copyright © 2015년 gyuchan. All rights reserved.
//

import Foundation

class HtNullableBool : NSObject {
    var isSet = false
    var value = false
    var didDoneMainJob = false
    var intVal = 0
    
    override init() {
        value = false
        super.init()
    }
    
    func initialize() {
        isSet = false
        didDoneMainJob = false
    }
    
    func doSetValue(pVal: Bool) {
        isSet = true
        value = pVal
    }
    
    func didMainJob() {
        didDoneMainJob = true
    }
    
    func validAndTrue() -> Bool {
        return isSet && value
    }
}

class HtUnitLogic : NSObject { // 바이패스 모드 화면 띄우는 로직..  delayTime 이내로는 불리더라도 실행 안되게 막는 용도..
    // 사용법 : 1 아래 두 함수를 정의..
    var theMainCondition: (Void)-> Bool = { return false }
    var theMainVoidJob: (Void)-> Void = { }
    // updateAction 을 불러 줌..  여러번 불려도 무방..
    
    var didDoneMainJob = false
    var resetTimer = Timer()
    let delayTime = 3.0
    
    func updateAction() {
        if didDoneMainJob { return } // 실행 했다면 스킵.
        if theMainCondition() {
            theMainVoidJob()
            didDoneMainJob = true

            resetTimer = Timer.scheduledTimer(timeInterval: delayTime, target: self,
                selector: #selector(HtUnitLogic.delayedAction), userInfo: nil, repeats: false)  // 한번만 실행..
        }
    }
    
    func delayedAction() {
        didDoneMainJob = false
    }
    
}

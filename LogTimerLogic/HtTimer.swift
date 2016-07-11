//
//  HtTimer.swift
//  Trainer
//
//  Created by Jongwoo Moon on 2016. 3. 7..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation

/**
 160307 : HtStopWatch 가 HtTimer 를 상속 받는 구조로 변경.  관련 함수 가져옴..


*/


class HtTimer : NSObject { // 조건부 타이머..  3초 지나면 나타나는 용도..
    var log = HtLog(cName: "HtTimer")
    var condTimeLimit: Double = 3, isPause = false, dueTime: Double = 0, totalPauseTime: Double = 0
    var theTime = NSDate.timeIntervalSinceReferenceDate()
    var pauseStartTime = NSDate.timeIntervalSinceReferenceDate()

    var timeSinceStart: Double { get { setDueTime(); return dueTime }}
    var timeSinceIntStr: String { get { return String(Int(timeSinceStart)) }}

    func Reset() {
        theTime = NSDate.timeIntervalSinceReferenceDate() // 현재 시간 설정.
        pauseStartTime = theTime
        totalPauseTime = 0
        isPause = false
        setDueTime()
        //log.printThisFNC("Reset", comment: "dueTime : \(dueTime) theTime : \(theTime) ", lnum: 1)
        log.endFunctionLog()
    }

    func IsConditionTrue() -> Bool { // 한계를 초과했을 때 true
        setDueTime()   //let delayTime = NSDate.timeIntervalSinceReferenceDate() - theTime
        return condTimeLimit < dueTime // delayTime
    }

    func setDueTime() {
        dueTime = NSDate.timeIntervalSinceReferenceDate() - theTime - totalPauseTime
        //print(" \(theTime)  \(totalPauseTime)  \t \(dueTime)")
        if isPause {
            //dueTime = dueTime - pauseStartTime
            dueTime = dueTime - (NSDate.timeIntervalSinceReferenceDate() - pauseStartTime)
        }
        //print(" \(theTime)  \(totalPauseTime)  \t\t \(dueTime)")
    }

    func timeInSec() -> String { // 소숫점 이하는 버린 333 초  스트링 리턴..
        setDueTime()
        return "\(Int(dueTime)) \(langStr.obj.second)"
    }

    // 160307
    func GetSecond(cnt: Int = 0) -> Double { // 시간 계산..  GetSecond(dObj.count) 여기서 0 이외의 수를 대입한 기능을 유일하게 쓴다.
        setDueTime() // 160307
        if cnt == 0 {
            return dueTime // NSDate.timeIntervalSinceReferenceDate() - theTime // 160307
        }
        if IsConditionTrue() {
            return dueTime // NSDate.timeIntervalSinceReferenceDate() - theTime // 160307
        } else {
            return -1
        }
    }

    func startOrReleaseToggle() {
        //print("   HtTimer :: startOrReleaseToggle      isPause : \(isPause)")
        if isPause { togglePause() } // 아니면 그냥 놔둠..
    }

    func forcePause() {
        //print("  HtTimer :: pause    isPause : \(isPause)")
        if !isPause { togglePause() }
    }

    func togglePause() {
        //print("  HtTimer :: togglePause >> isPause : \(isPause)")
        isPause = !isPause
        //print("  \t\t isPause : \(isPause)   end of togglePause")

        if isPause { // 시작..
            pauseStartTime = NSDate.timeIntervalSinceReferenceDate()
        } else {
            totalPauseTime += NSDate.timeIntervalSinceReferenceDate() - pauseStartTime
        }
    }
    
}

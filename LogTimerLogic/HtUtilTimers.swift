//
//  HtUtilTimers.swift
//  heartisense
//
//  Created by Jongwoo Moon on 2015. 10. 27..
//  Copyright © 2015년 gyuchan. All rights reserved.
//

import Foundation


class HtGenTimer : NSObject {
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    var endTime = NSDate.timeIntervalSinceReferenceDate()
    var totalSec: Double { get { return endTime - startTime } }
    var timeSinceStart: Double { get { return NSDate.timeIntervalSinceReferenceDate() - startTime } }
    var timeSinceEnd: Double { get { return NSDate.timeIntervalSinceReferenceDate() - endTime } }
    
    func markStart() { startTime = NSDate.timeIntervalSinceReferenceDate() }
    func markEnd() { endTime = NSDate.timeIntervalSinceReferenceDate() }
    
}

class HtDelayTimer : NSObject {
    var defaultDelayTime = 0.1
    var theTimer = NSTimer()
    var theAction: (Void)-> Void = { }
    
    func doAction() {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(defaultDelayTime * Double(NSEC_PER_SEC))),
            dispatch_get_main_queue(), theAction)
    }
    
    func cancel() {
        theTimer.invalidate()
    }
    
    func setDelay(delay:Double, closure:()->()) {  // 딜레이 함수..
        theAction = closure
        theTimer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self,
            selector: #selector(HtDelayTimer.doAction), userInfo: nil, repeats: false)  // 한번만 실행..
    }
}


//////////////////////////////////////////////////////////////////////     _//////////_     [   Pause ..  << >> ]    _//////////_
// MARK: -  Pause 용 타이머

class HtUnitJob : NSObject {
    var actTimeInSec:Double = 0
    var theAction: (Void)-> Void = { }
    
    override init() { super.init() }
    
    convenience init(pTime: Double, pAct : ()->()) {
        self.init()
        self.actTimeInSec = pTime
        self.theAction = pAct
    }
}

class HtPauseCtrlTimer : HtStopWatch {
    var arrJobs = [HtUnitJob]()
    
    func resetJobs() {
        resetTime()
        arrJobs = [HtUnitJob]()
    }
    
    func addJob(pTime: Double, pAct : (Void)->Void) {
        let newJob = HtUnitJob(pTime: pTime, pAct: pAct)
        arrJobs.append(newJob)
    }
    
    func updateJob() {
        setDueTime()
        
        if arrJobs.count == 0 || dueTime < arrJobs[0].actTimeInSec { return }
        
        let curJob = arrJobs[0]
        curJob.theAction()
        arrJobs.removeAtIndex(0)
    }
}



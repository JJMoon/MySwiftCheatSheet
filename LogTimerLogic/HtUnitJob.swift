//
//  HsNetUtils.swift
//  heartisense
//
//  Created by Jongwoo Moon on 2015. 10. 8..
//  Copyright © 2015년 gyuchan. All rights reserved.
//

import Foundation


class HtBaseJob : NSObject {
    var jobName = "Name"
    var retryCount: Int = 0, retryLimit: Int = 3
    var initJob:(Void)->Void = { }
    var didFinished:(Void) -> Bool = { return true }
    
    override init() {
        super.init();
    }
    
    convenience init(nm: String, retryLimitN: Int = 3) {
        self.init()
        jobName = nm; retryLimit = retryLimitN
    }
    
    func logFailure() {
        print("\n\n\n\n\n   HtBaseJob ...   logFailure :: ___  \(jobName) ___   \n\n\n\n\n")
    }
}


@objc
class UnitJob : HtBaseJob {
    
    var delayTime:Double = 0.2 // second
    var skipInitialStep = true, myJobWasDone = false
    
    var timer = NSTimer()
    
    var failJob:(Void)->Void = { }
    var lastJob:(Void)->Void = { }
    
    var nextJobObj: UnitJob?
    
    override init() {
        super.init()
    }
    
    convenience init(name: String) {
        self.init()
        jobName = name
    }
    
    func getEndOfNextJob() -> UnitJob {
        if nextJobObj == nil { return self }
        return (nextJobObj?.getEndOfNextJob())!
    }
    
    func cancelAllActions() {
        timer.invalidate()
        initJob = { }
    }
    
    func timerAction() {
        if skipInitialStep {
            skipInitialStep = false
            initJob()
            return
        }
        
        //print("\n\n  timerAction : \(self.jobName) \n\n")
        
        if self.didFinished() {
            print("\n\n\t\t\t\t\t\t UnitJob :  [ \(self.jobName) ]  didFinished : 다음 작업으로 ...   \n\n")
            self.lastJob()
            self.nextJobObj?.startProcess()
            myJobWasDone = true
            timer.invalidate()
        } else {
            if self.retryLimit == -1 {
                initJob()
                return
            }
            if self.retryCount < self.retryLimit {
                initJob()
            } else {
                print("\n\n\n\n\n\n\n\n\n\n")
                print("\t\t\t UnitJob :  [ \(self.jobName) ]   Not Finished ...    Final Fail   >>>>>      [ retried  \( self.retryCount) ]")
                
                self.failJob()
                timer.invalidate()
                //print(" timer :: valid  \(timer.valid) ")
            }
            
            print("\t\t\t UnitJob :  [ \(self.jobName) ]   Retry  >>   count :: \(self.retryCount + 1) \n\n\n")
            print("\n\n\n\n\n\n\n\n\n\n")
            self.retryCount += 1
        }
    }
    
    func startProcess() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(self.delayTime, target: self, selector: "timerAction", userInfo: nil, repeats: true)
    }
}

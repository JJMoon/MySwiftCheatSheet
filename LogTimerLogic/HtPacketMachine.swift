//
//  HtPacketMachine.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2015. 12. 9..
//  Copyright © 2015년 IMLab. All rights reserved.
//

import Foundation

/**
 
 패킷 어레이를 갖고 작업.  트레이너가 없으면 리트라이를 계속하는데..  이를 제지해야 함.


**/

class HtPacketMachine : NSObject {
    var log = HtLog(cName: "HtPacketMachine")
    var arrPckt = [HtBaseJob]()
    var timer = NSTimer()
    
    //

    override init() {
        super.init()
        
    }
    
    convenience init(interval: Double) {
        self.init()
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self,
                                                       selector: #selector(HtPacketMachine.timerAction),
                                                       userInfo: nil, repeats: true)
    }
    
    func addBaseJob(aJob: HtBaseJob) {
        arrPckt.append(aJob)
    }
    

    func timerAction() {
        
        if (arrPckt.count == 0) { return }

        //log.printThisFNC("timerAct", comment: "현재 arrPckt : \(arrPckt.count) ea,  First : <\(arrPckt[0].jobName) > ) ", lnum: 0)
        
        let curJob = arrPckt[0]
        
        if (curJob.retryCount == 0) {
            log.logThis("   First try  :::  initJob of  \(curJob.jobName)    남은 작업 수 : \(arrPckt.count)  ", lnum: 1)
            curJob.initJob();
            curJob.retryCount = 1;
            return;
        } else {
            if (curJob.didFinished()) { // OK..  done..
                //curJob = nil;
                log.logThis("arrPckt   removefirst   \(curJob.jobName)    남은 작업 수 : \(arrPckt.count)  ")
                arrPckt.removeFirst()// [arrPckt removeObjectAtIndex:1];
                return;
            }
        }
        
        if (curJob.retryLimit <= curJob.retryCount) {
            //log.logUiAction("  retryLimit <= curJob.retryCount    \(curJob.jobName)   실패 .... ", lnum:10)
            arrPckt.removeFirst()
        } else {
            log.logThis("   @ 68    initJob  of   \(curJob.jobName)   retryNum : \(curJob.retryCount)   남은 작업 수 : \(arrPckt.count)", lnum: 1)
            curJob.initJob();
            curJob.retryCount += 1
            // log.logThis("arrPckt   \(curJob.jobName)   retry  ...   \(curJob.retryCount)  ", lnum: 5)
        }
        
        log.함수차원_출력_End()
    }
    
}
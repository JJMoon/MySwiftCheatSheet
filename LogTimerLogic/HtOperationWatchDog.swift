//
//  HtOperationWatchDog.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2015. 12. 4..
//  Copyright © 2015년 IMLab. All rights reserved.
//

import Foundation
//////////////////////////////////////////////////////////////////////     _//////////_     [  HtOperationWatchDog  ]    _//////////_
class HtOperationWatchDog: NSObject {
    var log = HtLog(cName: "HtOperationWatchDog")
    var errorDetectedN = 0, cnt = 0
    
    var watchTimer = NSTimer()
    var bleManager: HsBleManager?
    var arrDates = [Double]()
    
    override init() {
        super.init()
        watchTimer = NSTimer.scheduledTimerWithTimeInterval(1, // second
            target:self, selector: Selector("watchTimerAction"),
            userInfo: nil, repeats: true)
    }
    
    deinit {
        watchTimer.invalidate()
    }
    
    convenience init(bleMan: HsBleManager) {
        self.init()
        bleManager = bleMan
    }
    
    func injectParsingAction(curTime: Double) {
        // log.printThisFunc("injectParsingAction : \(curTime)    count : \(arrDates.count)")
        arrDates.append(curTime)
    }
    
    func removeOldActions() {
        let old = arrDates.filter { (theTime) -> Bool in
            let dist = NSDate().timeIntervalSinceReferenceDate - theTime
            return dist > 1 // 최근 1초 이내만 살림..
        }
        arrDates.removeFirst(old.count)
    }
    
    func watchTimerAction() {
        if AppIdTrMoTe == 2 && !isAdult { return }

        if bleManager?.isConnected == false || bleManager?.isConnectionTotallyFinished == false {
            return // isConnectionTota ...  여기서 접속 시 상태를 바꿈...  
        }

        //log.printThisFunc("watchTimerAction \(arrDates.count)")
        removeOldActions()        //if bleManager?.isPausing == true || isBypassMode == true { return }
        cnt += 1

        var denomi = 3
        if isTrainerConnected { denomi = 10 }

        if cnt % denomi == 1 && AppIdTrMoTe == 1 { // [_cellService requestSensorInfo:0x06];
            //log.printAlways("  트레이너 연결 확인 ", lnum: 1)
            bleManager?.cellService?.requestSensorInfo(0x06)
            return
        }

        if bleManager?.isPausing == true { return }

        switch (bleManager?.bleState)! {
        case .S_CALIBRATION, .CAL_LOAD, .CAL_NEW_CC, .CAL_NEW_RP: // .S_INIT0 일때도 작동.
            return
            
        case .S_STEPBYSTEP_BREATH, .S_STEPBYSTEP_COMPRESSION, .S_WHOLESTEP_BREATH, .S_WHOLESTEP_COMPRESSION, .S_WHOLESTEP_PRECPR,
            .BypassStepComp, .BypassStepBrth:
            if (arrDates.count > 5 && bleManager?.operationOn == true) {  // 최근 패킷 5개 이상이면 이상 무..
                errorDetectedN = 0
            } else {
                errorDetectedN += 1
                //log.printAlways("   Error  :: It's Operating 중.. \t  패킷수 : \(arrDates.count)    \(errorDetectedN) ", lnum: 1)
            }
        default: // 다른 스텝에서..+
            if (arrDates.count < 2 && bleManager?.operationOn == false) {
                errorDetectedN = 0
            } else {
                errorDetectedN += 1
                //log.printAlways("   Error  :: 현재 멈춘 상태 ..   \t 패킷수 : \(arrDates.count)     \(errorDetectedN) ", lnum: 1)
            }
        }
        if errorDetectedN > 3 {
            //log.printAlways("   Error  ::   errorDetectedN  \(errorDetectedN)  > 3   ", lnum: 1)
            operationCorrectProcess()
            errorDetectedN = 0
        }
    }
    
    func operationCorrectProcess() {
        //log.printAlways("   Error  ::   errorDetectedN __> \(errorDetectedN) > 3      operationCorrectProcess   ", lnum: 2)
        errorDetectedN = 0
        switch (bleManager?.bleState)! {
        case .S_STEPBYSTEP_BREATH, .S_STEPBYSTEP_COMPRESSION, .S_WHOLESTEP_BREATH, .S_WHOLESTEP_COMPRESSION, .S_WHOLESTEP_PRECPR,
            .BypassStepComp, .BypassStepBrth:
            //log.logThis("  bleManager?.operationOn = false   \t\t  >>> operationStart ", lnum: 1)
            bleManager?.operationOn = false
            bleManager?.operationStart()
        default:
            //log.logThis("  bleManager?.operationOn =  true   \t\t  >>> operationSop ", lnum: 1)
            bleManager?.operationOn = true
            bleManager?.operationStop()
        }
    }
}





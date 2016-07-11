//
//  HtStopWatch.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2016. 1. 14..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation




//////////////////////////////////////////////////////////////////////     _//////////_     [   Pause ..  << >> ]    _//////////_
// MARK: -  Stop Watch    MMSSHH

class HtStopWatch : HtTimer { // 1/100 초까지 표시하는 용도...
    var log2 = HtLog(cName: "HtStopWatch")

    func resetTime() {
        super.Reset()
        //print("  HtStopWatch :: reset Time ....       isPause : \(isPause)")
        //log.printThisFunc("resetTime :: \(theTime)", lnum: 1)
    }

    func timeMMSSHH() -> String { // 1/100 sec ...
        setDueTime()
        //var tSec = NSDate.timeIntervalSinceReferenceDate() - theTime - totalPauseTime
        // if isPause {            tSec = tSec - pauseStartTime        }
        let mm = Int(dueTime / 60)
        let ss:Double = dueTime - Double(60 * mm)
        let ssInt = Int(ss)
        let hhInt = Int( 100 * (ss - Double(ssInt)))
        var rStr = "\(mm):"
        if ssInt < 10 { rStr += "0\(ssInt):" } else { rStr += "\(ssInt):" }
        if hhInt < 10 { rStr += "0\(hhInt)" } else { rStr += "\(hhInt)" }
        return rStr
    }

}





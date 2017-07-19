//
//  HtLog.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2015. 11. 19..
//  Copyright © 2015년 IMLab. All rights reserved.
//

import Foundation


class HtLog : NSObject {
    init (name: String) {  self.clsName = name; willPrn = true  }
    init (cName: String, active: Bool = true) {  self.clsName = cName; willPrn = active  }
    //init (cName: String, bleMan: HsBleManager) {  self.clsName = cName; bleObj = bleMan }

    //var bleObj: HsBleManager?

    var prjtString: String {
        get { return "    HS : Prjt " }
    }

    static let st = NSDate.timeIntervalSinceReferenceDate
    static let uiMarker = "===================================================================================================================  UI ====="
    static let Marker = " =============================================================================================   Method >>>"
    var willPrn = true, willPrnFun = true, clsName : String = "NSObject", funName : String = "Void", cnt = 0
    var ct: String { get { return (NSDate.timeIntervalSinceReferenceDate - HtLog.st).format(".3") } } // 진행 시간 (초)
    
    func doNotPrintThisClass() { willPrn = false }
    
    func getFunName() -> String { return "  [[ \(clsName) :: \(funName) ]]  " }
    
    func newLine(lnum:Int) {
        if lnum == 0 { return }
        for _ in 0...lnum-1 { print("...") }
    }

    //var commonStr: String {get { return " \(prjtString) ... " + getFunName() }    }
    
    func logBase(lnum:Int = 0, pStr:String = ".") {
        if willPrn && willPrnFun {
            newLine(lnum: lnum)
            print("\(ct) sec  \(prjtString) \t  \(getFunName())  ... " + pStr)
            newLine(lnum)
        }
    }

    func printThisFNC(funcName:String, comment: String, lnum:Int = 2) {
        willPrnFun = true;  funName = funcName;
        print(HtLog.Marker + prjtString)
        logBase(0, pStr: "   ======   <<<  \(comment)  >>> ")
        newLine(lnum)
    }

    func printThisFunc(funcName:String = "  func  ", lnum:Int = 2) {
        willPrnFun = true;  funName = funcName;
        newLine(lnum)
        print(HtLog.Marker + prjtString)
        logBase(0, pStr: "====== Func Started ===>>>")
        newLine(lnum)
    }
    
    func printAlways(stt: String = "  {{{{{  This is important  }}}}}   ", lnum:Int = 5) {
        let temp = willPrnFun;    willPrnFun = true
        newLine(lnum)
        print(HtLog.Marker + prjtString)
        print("\n \(ct) sec  \(prjtString) \t  \(getFunName())  ... #####__     \(stt)     __##### PrintAlways \n")
        print(HtLog.Marker)
        newLine(lnum)
        willPrnFun = temp
    }

    func logUiAction(cont:String = "<<< No Message >>>", lnum:Int = 3, printOn: Bool = true) {
        willPrnFun = true
        newLine(lnum);
        print(HtLog.uiMarker); print(HtLog.uiMarker); print(HtLog.uiMarker)
        logBase(1, pStr:  "  ... >>>  \(cont) <<<  UI ACTION  >>>")
        print(HtLog.uiMarker); print(HtLog.uiMarker); print(HtLog.uiMarker)
        newLine(lnum)
        willPrn = printOn
    }

    func logThis(cont:String = "default", lnum:Int = 0) {
        logBase(lnum, pStr: ".... \(cont)  ... ")
    }

    func endFunctionLog() {
        if willPrnFun { print(HtLog.Marker) }
        함수차원_출력_End()
    }

    func 함수차원_출력_End() {
        funName = "func"
        willPrnFun = false
    }
}


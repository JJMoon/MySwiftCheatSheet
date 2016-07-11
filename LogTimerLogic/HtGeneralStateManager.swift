//
//  HtGeneralStateManager.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2015. 12. 14..
//  Copyright © 2015년 IMLab. All rights reserved.
//

import Foundation



//////////////////////////////////////////////////////////////////////     _//////////_     [   State Manager ..  << >> ]    _//////////_
// MARK: -  상태 관리 매니저..

class HtUnitState : NSObject {
    var name = "UnitState", entryActionDone = false
    var dueTime:Double = -1
    var entryAction: (Void)-> Void = { }
    var durinAction: (Void)-> Void = { }
    var exittAction: (Void)-> Void = { }
    var exitCondition: (Void)-> Bool = { return false }
    var skipAction: (Void)-> Void = { } // 스킵할 때 추가로 해 줘야 할 일. 그냥 넘어갈 땐 실행하지 않음.
    
    override init() {
        super.init()
    }
    
    convenience init(duTime: Double, myName: String) {
        self.init()
        dueTime = duTime
        name = myName
    }

    func resetState() {
        entryActionDone = false
    }
}

class HtGeneralStateManager : HtStopWatch {
    var arrState = [HtUnitState]()
    var curState: HtUnitState? = nil
    var machineName = " 상태머신 이름 "
    let Mark = "================================================================ State Manager =================== "


    override init() {  super.init()    }

    convenience init(myName: String) {
        self.init()
        machineName = myName
        log.clsName = "HtGeneralStateManager"
    }

    func prepareActions() {
        curState = arrState[0]
    }
    
    private func startEntryAction() {
        //print("\n\n\n\n\n")
        print ("\n\(Mark)    Entry Action  <<<<<< ")
        //print ("\(Mark)    Entry Action  <<<<<< ")
        print ("\t\t\t  Entry Action of [ \((curState?.name)!)]  in  << \(machineName) >>  =====  ")
        print ("\(Mark)    Entry Action  <<<<<< ")
        //print("\n\n\n\n\n")
        curState?.entryAction()
        curState?.entryActionDone = true
        resetTime()
    }
    
    func update() {
        
        if curState == nil { return }
        
        if curState?.entryActionDone == false { startEntryAction(); return } // entry action 수행.. 한 후 간격 띄었다가..  during action..
        
        curState?.durinAction()
        
        setDueTime()
        
        let exitAndGotoNext  = {
            print("\n\n  ========  ___________ Exit Action of [ \((self.curState?.name)!)] in  << \(self.machineName) >> =====  ")
            self.curState?.exittAction()
            print("  ========  ___________ go to next State  in  << \(self.machineName) >> =====   ----------- >>>>>>>>>  \n\n\n")
            self.goToNextStateWithSkipAction(false) // 이때는 skipAction 실행 없이 넘어간다.
        }
        
        if curState?.dueTime > 0 && curState?.dueTime < dueTime {
            print("curState?.dueTime > 0 && curState?.dueTime < dueTime {")
            print("\(curState?.dueTime) > 0 && curState?.dueTime < \(dueTime) {")
            exitAndGotoNext()
        }
        if curState?.exitCondition() == true {
            print("curState?.exitCondition() == true {")
            exitAndGotoNext()
        }
    }
    
    func goToNextStateWithSkipAction(doSkipAction: Bool) {
        let idx = arrState.indexOf(curState!)
        if doSkipAction {
            curState!.skipAction()
        }
        if (idx! + 1) < arrState.count {
            curState?.resetState()
            curState = arrState[idx! + 1]
            startEntryAction()
        } else {
            curState = nil
        }
    }
    
    func addAState(aState : HtUnitState) {
        arrState.append(aState)
    }
    
    func setState(newSttName: String) {
        log.printThisFunc("setState : From \(curState?.name) To : \(newSttName)  in  << \(self.machineName) >> ==  \n")
        let sameNameObj = arrState.filter { (objt) -> Bool in
            return objt.name == newSttName
        }
        if sameNameObj.count == 1 {
            curState?.resetState()
            curState = sameNameObj[0]
        } else {
            log.printThisFunc("setState")
            log.logThis(" 상태가 없거나 중복... 이름 확인.. 필요  \(newSttName) ")
        }
    }
}



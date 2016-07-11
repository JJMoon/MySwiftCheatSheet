//
//  HoldingTimeView.swift
//  Trainer
//
//  Created by Jongwoo Moon on 2016. 2. 17..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation


// Heartisense Operation View
class HovHoldingTimeView : UIView {
    var log = HtLog(cName: "HovHoldingTimeView")

    var dObj = HsBleManager.inst().dataObj
    var currentStep = HsBleManager.inst().bleState

    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var labelHoldTimeMsg: UILabel!

    func update() {
        let stage = HsBleManager.inst().stage
        currentStep = HsBleManager.inst().bleState

        // 압박 중단 시간 표시...
        let theTimer = HsBleManager.inst().calcManager.compHoldTimer  // HtTimer 타이머..
        let holdTime: Double = theTimer.GetSecond(dObj.count)

        labelSecond.text = "\(Int(holdTime))" //[NSString stringWithFormat: @"%d", (int)holdTime];

        if 10 < Int(holdTime) {
            labelSecond.textColor = UIColor.redColor()
            labelHoldTimeMsg.textColor = UIColor.redColor()
        } else {
            labelSecond.textColor = colorBarBgGrn
            labelHoldTimeMsg.textColor = colorBarBgGrn
        }

        switch currentStep {
        case  .S_WHOLESTEP_AED, .S_WHOLESTEP_DESCRIPTION, .S_WHOLESTEP_BREATH:
            self.hidden = true;         return
        default: break
        }

        if (self.hidden) { // 안보이면..
            if (currentStep == .S_WHOLESTEP_COMPRESSION) {
                if (dObj.count == 0 && HsBleManager.inst().stage > 1) { // 스테이지 바뀌고 나서 켜는 경우..
                    self.hidden = false;
                    log.logThis("  count \(dObj.count) == 0 && stage \(stage) > 1  ", lnum: 5)
                    return
                } // 2스테이지 이상 처음 공백..
                if (HsBleManager.inst().calcManager.isCycleStart == false && holdTime > 2) {
                    if stage == 1 && dObj.count == 0 { return }   // 처음의 예외..

                    log.logThis("  holdTime :: \(holdTime) > 2  && stage \(stage) > 1  ", lnum: 5)
                    self.hidden = false;
                    return
                } // 켜고.
            }
        } else { // 보이는 상태에선 끄는 조건.
            if (currentStep == .S_WHOLESTEP_COMPRESSION && HsBleManager.inst().stage == 1 && dObj.count == 0) {
                self.hidden = true;  return
            }

            if (currentStep != .S_WHOLESTEP_COMPRESSION || (  dObj.count > 0 && holdTime < 0 )) { // 호흡에서 바뀐 경우는 무조건 켜주기.. 압박이 들어오는 경우.
                log.logThis("  @116    호흡에서 바뀐 경우는 무조건 켜주기.. 압박이 들어오는 경우.  ", lnum: 5)
                self.hidden = true;
            } // else ; // 그냥 놔두고..
        }
    }

    // MARK:  언어 세팅.
    func setLanguageString() {
        //bttnSaveData.setTitle(local Str("save_data"), forState: UIControlState.Normal)
        labelHoldTimeMsg.text = langStr.obj.hands_off_time // local Str("hold_time")
    }
    
}


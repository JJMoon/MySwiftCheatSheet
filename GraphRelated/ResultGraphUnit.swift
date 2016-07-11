//
//  ResultDetail.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2015. 11. 11..
//  Copyright © 2015년 IMLab. All rights reserved.
//

import Foundation
import UIKit


class ResultGraphUnit : UITableViewCell {
    @IBOutlet weak var vwDetail: CompStrokeView! // HtVerticalGraph
    @IBOutlet weak var vwDetailL: ResultSpeedView!
    @IBOutlet weak var vwDetailBreath: ResultBreathView!
    @IBOutlet weak var vwAccuracy: ResultAccurateView!

    @IBOutlet weak var labelCycleNum: UILabel!
    @IBOutlet weak var labelCompDepth: UILabel!
    @IBOutlet weak var labelCompSpeed: UILabel!
    @IBOutlet weak var labelCompTimeAndSpeed: UILabel!
    @IBOutlet weak var labelBreathAmount: UILabel!
    @IBOutlet weak var labelBreathTime: UILabel!
    @IBOutlet weak var labelCompPosition: UILabel!

    var strokeObj = HmUnitSet()
    var bleMan: HsBleSuMan?
    var dbStudent: HmStudent?
    
    func setCycleNumber(n: Int) { // 0, 1, 2 ..
        
        print("  arrNum : \(bleMan?.dataObj.arrSet.count)  n : \(n)  ")

        if bleMan != nil {
            strokeObj = (bleMan?.dataObj.arrSet[n])!  // n - 1 아님..
        } else {
            print("  (dbStudent?.myDataFromDB?.arrSet.count : \(dbStudent?.myDataFromDB?.arrSet.count) ")
            strokeObj = (dbStudent?.myDataFromDB?.arrSet[n])!
        }
        print("\n\n\n ResultDetailVC : viewDidLoad")
        
        labelCycleNum.text = "Set \(strokeObj.setNum)"
        
        labelCompTimeAndSpeed.text = "Due Time : \( formatDouble2f(strokeObj.ccTime)) / Mean Speed : \(strokeObj.분당압박횟수()) cycle/min"
        
        vwDetailBreath.strokeObj = strokeObj
        vwDetailBreath.setNeedsDisplay()
        
        vwDetail.strokeObj = strokeObj
        vwDetail.setNeedsDisplay()
        
        vwDetailL.strokeObj = strokeObj
        vwDetailL.setNeedsDisplay()

        vwAccuracy.setObj = strokeObj
        vwAccuracy.setNeedsDisplay()

        setLanguageString(n)
        
        //strokeObj.autoGen4Debug(30)  // 4 debug
    }
    
    func xxxcellDidAppear() {
        print("\n\n\n ResultDetailVC : cellDidAppear")
        vwDetail.strokeObj = self.strokeObj
        vwDetailL.strokeObj = self.strokeObj
        vwDetailBreath.strokeObj = self.strokeObj
        
        vwDetail.setNeedsDisplay()
        vwDetailL.setNeedsDisplay()
        vwAccuracy.setNeedsDisplay()
    }

    // MARK:  언어 세팅.
    func setLanguageString(n: Int) {
        labelCycleNum.text = " \(n+1) \(langStr.obj.cycle)"
        labelCompDepth.text = langStr.obj.compression_depth
        labelCompSpeed.text = langStr.obj.compression_rate
        // 소요시간 : 333 초, 평균 속도:  222/분
        labelCompTimeAndSpeed.text = strokeObj.getLabelCompTimeAndSpeed()
        labelBreathAmount.text = langStr.obj.breath_volume
        labelBreathTime.text = "\(langStr.obj.hands_off_time) \(strokeObj.holdTimeStr) \(langStr.obj.second) "
        labelCompPosition.text = langStr.obj.compression_position
    }
}


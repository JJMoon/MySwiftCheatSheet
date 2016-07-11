//
//  HmGraphicBase.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2015. 11. 13..
//  Copyright © 2015년 IMLab. All rights reserved.
//

import Foundation

//////////////////////////////////////////////////////////////////////     _//////////_     [     ]    _//////////_   Go to Main View
// MARK:  Graph

class GraphSub3Dot: HtGraph {
    var log = HtLog(cName: "Ht3DotLayerGraph")
    var dotDia:CGFloat = 0, midCol:UIColor = UIColor.greenColor()
    var pitch:CGFloat = 1, dotAreaX1:CGFloat = 0, dotAreaX2:CGFloat = 0
    var staX:CGFloat = 0, distY:CGFloat = 0, fastY:CGFloat = 0, normY:CGFloat = 0, slowY:CGFloat = 0
    var font = UIFont(name: "Helvetica Neue", size: HmGraphSetting.inst.fontSizeSmallTitle)
    let paraStyle = NSMutableParagraphStyle()
    
    override init() {  super.init()  }
    convenience init(pArea: CGRect, xNum: Int, yNum: Int,  dotDia: CGFloat, midColor: UIColor, dotX1:CGFloat, dotX2:CGFloat) {
        self.init()
        area = pArea
        numX = xNum; numY = yNum
        self.dotDia = dotDia
        midCol = midColor
        dotAreaX1 = dotX1; dotAreaX2 = dotX2
        //print("  area : \(area?.width) X \(area?.height) ") //  50 ~ 384 ..  334 X 220
    }
    
    func drawBreathElements(obj: HmUnitSet) { // 호흡 그래프 그리기..
        hmStrokeObj = obj
        distY = (area?.height)! * 0.25
        fastY = distY * 0.5; normY = fastY + distY; slowY = normY + distY
        pitch = ( (area?.width)! - dotAreaX1) / 3 + 30 // 350 - 70 / 3 ...  100 인데... 10은 보정 수..
        //log.logThis(" (area?.width)!  \((area?.width)!)  dotAreaX1 : \(dotAreaX1)  ==> pitch   \(pitch)   ", lnum: 2)
        drawArea(0.30, loVal: 0.65)
        drawDashLines(0.30, loVal: 0.65)
        drawBreathTexts()
        drawBreathBars()
    }
    
    func drawSpeedElements(obj: HmUnitSet) {
        hmStrokeObj = obj
        distY = (area?.height)! * 0.25
        staX = dotAreaX1 + pitch * 0.5;    fastY = distY * 0.5; normY = fastY + distY; slowY = normY + distY
        pitch = (dotAreaX2 - dotAreaX1) / CGFloat(numX)
        drawArea(0.30, loVal: 0.70)
        drawSpeedDots()
        drawDashLines(0.30, loVal: 0.70)
        drawSpeedTexts()
    }
    
    func drawArea(upVal: CGFloat, loVal: CGFloat) { // 0.75 를 100으로 해서 계산해야 함..
        let yUp = (area?.height)! * 0.75 * upVal, yLo = (area?.height)! * 0.75 * loVal
        let x1 = (area?.origin.x)!, x2 = x1 + (area?.width)!
        let bezPath = UIBezierPath()
        bezPath.moveToPoint(CGPoint     (x: x1, y: yUp))
        bezPath.addLineToPoint(CGPoint  (x: x2, y: yUp))
        bezPath.addLineToPoint(CGPoint  (x: x2, y: yLo))
        bezPath.addLineToPoint(CGPoint  (x: x1, y: yLo))
        bezPath.closePath()
        //bezPath.lineWidth = 1  //color.setStroke();      bezPath.stroke()
        midCol.setFill();        bezPath.fill()
    }

    // MARK:  대쉬 라인 ..  여러개
    func drawDashLines(upVal: CGFloat, loVal: CGFloat) { // 0.75 를 100으로 해서 계산해야 함..
        let bezPath = UIBezierPath()
        let curCol = HmGraphSetting.inst.graphGreen
        let x1:CGFloat = (area?.origin.x)!, x2:CGFloat = x1 + (area?.width)!
        //let yUp:CGFloat = (area?.height)! * 0.25, yLo:CGFloat = (area?.height)! * 0.5, yBlack:CGFloat = (area?.height)! * 0.75
        let yUp:CGFloat = (area?.height)! * 0.75 * upVal, yLo:CGFloat = (area?.height)! * 0.75 * loVal, yBlack:CGFloat = (area?.height)! * 0.75
        bezPath.moveToPoint     (CGPoint(x: x1, y: yUp))
        bezPath.addLineToPoint  (CGPoint(x: x2, y: yUp))
        bezPath.moveToPoint     (CGPoint(x: x1, y: yLo))
        bezPath.addLineToPoint  (CGPoint(x: x2, y: yLo))
        curCol.setStroke()
        bezPath.lineWidth = 1
        let dash :[CGFloat] = [ 3, 2 ]
        bezPath.setLineDash(dash, count: 2, phase: 0)
        bezPath.stroke()
        
        bezPath.lineWidth = 0.5
        bezPath.setLineDash([0, 0], count: 2, phase: 0)
        bezPath.moveToPoint     (CGPoint(x: x1, y: yBlack))
        bezPath.addLineToPoint  (CGPoint(x: x2, y: yBlack))
        HmGraphSetting.inst.graphText.setStroke()
        bezPath.stroke()
    }

    // MARK:  대쉬 라인 :  하나 그리기.
    func drawDashLine(color: UIColor, staX: CGFloat, staY: CGFloat, endX: CGFloat, endY: CGFloat) {  //  단위 대쉬 라인 그리기
        let bezPath = UIBezierPath()
        bezPath.moveToPoint     (CGPoint(x: staX, y: staY))
        bezPath.addLineToPoint  (CGPoint(x: endX, y: endY))
        color.setStroke()
        bezPath.lineWidth = 1
        let dash :[CGFloat] = [ 3, 2 ]
        bezPath.setLineDash(dash, count: 2, phase: 0)
        bezPath.stroke()
    }
    
    func drawBreathBars() { // 호흡 바 그리기.
        log.printThisFunc("drawBreathBars() ", lnum: 3)
        let barWidthH:CGFloat = 30, yBlack:CGFloat = (area?.height)! * 0.75
        //var coX:CGFloat = (area?.origin.x)! + dotAreaX1 + pitch
        var coX:CGFloat = dotAreaX1 + pitch

        log.logThis("  breath num : \(hmStrokeObj.arrBreath.count)", lnum: 0)
        log.logThis("  그래프 위치 값 ...  \(area?.origin.x) +   \(dotAreaX1) + \(pitch)  ")
        var number12 = 1

        for (_, sObj) in hmStrokeObj.arrBreath.enumerate() {
            var curCol = HmGraphSetting.inst.graphYello
            //if sObj.amount == .Good {
            if 35 < sObj.max && sObj.max < 70 {  // 바 색깔 조정.
                curCol = HmGraphSetting.inst.graphGreen
            }
            let yUp:CGFloat = (100.0 - CGFloat(sObj.max)) * (area?.height)! * 0.75 / 100
            let x1 = coX - barWidthH, x2 = coX + barWidthH
            let bezPath = UIBezierPath()
            bezPath.moveToPoint(CGPoint     (x: x1, y: yUp))
            bezPath.addLineToPoint(CGPoint  (x: x2, y: yUp))
            bezPath.addLineToPoint(CGPoint  (x: x2, y: yBlack))
            bezPath.addLineToPoint(CGPoint  (x: x1, y: yBlack))
            bezPath.closePath()
            curCol.setFill()  //bezPath.lineWidth = 1  //color.setStroke();      bezPath.stroke()
            bezPath.fill()

            let numStr = String(number12)
            let attributes = [
                NSForegroundColorAttributeName: HmGraphSetting.inst.graphText, NSParagraphStyleAttributeName: paraStyle,
                NSObliquenessAttributeName: 0,      NSFontAttributeName: font!  ]
            numStr.drawInRect(CGRectMake(coX, slowY + distY * 0.8, 100.0, 30.0), withAttributes: attributes as? [String : NSObject])
            number12 += 1
            coX += pitch
        }
        log.함수차원_출력_End()
    }
    
    func drawBreathTexts() {
        let positionX:CGFloat = 50, over = langStr.obj.excessive, good = langStr.obj.good_amount,
        short = langStr.obj.insufficient, diffY = fastY * -0.2
        //let coX1 = (area?.origin.x)! + dotAreaX1 + pitch - 30, coX2 = coX1 + pitch
        let coX1 = (area?.origin.x)! + dotAreaX1 + pitch, coX2 = coX1 + pitch
        
        //paraStyle.lineSpacing = 6.0
        // set the Obliqueness to 0.1
        let skew = 0.1
        var attributes: NSDictionary = [
            NSForegroundColorAttributeName: HmGraphSetting.inst.graphYello, NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,      NSFontAttributeName: font!  ]
        over.drawInRect(CGRectMake(positionX, fastY - diffY, 100.0, 30.0), withAttributes: attributes as? [String : AnyObject])
        short.drawInRect(CGRectMake(positionX, slowY - diffY, 100.0, 30.0), withAttributes: attributes as? [String : AnyObject])
        attributes = [
            NSForegroundColorAttributeName: HmGraphSetting.inst.graphGreen , NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,      NSFontAttributeName: font!  ]
        good.drawInRect(CGRectMake(positionX, normY - diffY, 100.0, 30.0), withAttributes: attributes as? [String : AnyObject])
        
//        let str1 = "1", str2 = "2"
//        
//        attributes = [
//            NSForegroundColorAttributeName: HmGraphSetting.inst.graphText, NSParagraphStyleAttributeName: paraStyle,
//            NSObliquenessAttributeName: 0,      NSFontAttributeName: font!  ]
        //str1.drawInRect(CGRectMake(coX1, slowY + distY * 0.8, 100.0, 30.0), withAttributes: attributes as? [String : AnyObject])
        //str2.drawInRect(CGRectMake(coX2, slowY + distY * 0.8, 100.0, 30.0), withAttributes: attributes as? [String : AnyObject])
    }
    
    func drawSpeedTexts() {
        let positionX:CGFloat = 50, fast = langStr.obj.fast, norm = langStr.obj.good_rate, slow = langStr.obj.slow, diffY = fastY * 0.8

        let skew = 0.1
        var attributes: NSDictionary = [
            NSForegroundColorAttributeName: HmGraphSetting.inst.graphYello, NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,      NSFontAttributeName: font!  ]
        fast.drawInRect(CGRectMake(positionX, fastY - diffY, 100.0, 30.0), withAttributes: attributes as? [String : AnyObject])
        slow.drawInRect(CGRectMake(positionX, slowY - diffY, 100.0, 30.0), withAttributes: attributes as? [String : AnyObject])
        attributes = [
            NSForegroundColorAttributeName: HmGraphSetting.inst.graphGreen , NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,      NSFontAttributeName: font!  ]
        norm.drawInRect(CGRectMake(positionX, normY - diffY, 100.0, 30.0), withAttributes: attributes as? [String : AnyObject])
    }

    /// 속도 점 표시...
    private func drawSpeedDots() {
        //log.printThisFunc("drawSpeedDots")
        log.logThis(" hmStrokeObj.arrComprs count >> :  \(hmStrokeObj.arrComprs.count)  ")

        staX = 269
        var xStand = staX
        
        for (idx, sObj) in hmStrokeObj.arrComprs.enumerate() {
            if idx == 30 { break }   //print("  Circle at \(staX),  \(normY)")

            var coY = normY, dotCol = HmGraphSetting.inst.graphGreen
            if sObj.period <= 0.5 { coY = fastY; dotCol = HmGraphSetting.inst.graphYello } // Fast
            if 0.6 <= sObj.period { coY = slowY; dotCol = HmGraphSetting.inst.graphYello } // Slow

            if 0 < sObj.wPosiIdx {
                drawX(xStand, arrowY: coY - 6, size: 12, color: UIColor.grayColor())
                xStand += pitch
                continue
            }

            print("  sObj.period  :  \(idx)  \(sObj.period)")  // 0.5 <  < 0.6

            if 0.5 < sObj.period && sObj.period < 0.6 {
                drawCircle(xStand, corY: normY, dia: dotDia, col: HmGraphSetting.inst.graphGreen)
            } else if sObj.period <= 0.5 { // Fast
                drawCircle(xStand, corY: fastY, dia: dotDia, col: HmGraphSetting.inst.graphYello)
            } else {
                drawCircle(xStand, corY: slowY, dia: dotDia, col: HmGraphSetting.inst.graphYello)
            }
            xStand += pitch
        }

        // 카운터 쓰기...        print("  staX  \(staX),  ")
        for idx in 0...29 {
            if (idx % 5) == 4 {
                let str = "\(idx+1)"
                var coX = staX - dotDia * 0.5
                if idx > 6 { coX -= dotDia * 0.5 } // 10 같은 두자릿 수 처리
                let attributes: NSDictionary = [
                    NSForegroundColorAttributeName: HmGraphSetting.inst.graphText, NSParagraphStyleAttributeName: paraStyle,
                    NSObliquenessAttributeName: 0,      NSFontAttributeName: font!  ]
                
                if idx > 9 { coX = coX - dotDia * 0.5 }
                str.drawInRect(CGRectMake(coX, slowY + distY * 0.8, 30.0, 30.0), withAttributes: attributes as? [String : AnyObject])

                print("  pitch is ...  \(pitch),    coX : \(coX)   Y 위치 : \(slowY + distY * 0.8)")
            }
            staX += pitch
        }
        log.함수차원_출력_End()
    }
}

//
//  ResultAccurateView.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2016. 1. 13..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation


//////////////////////////////////////////////////////////////////////     _//////////_     [      ResultBreathView : 호흡 뷰..      ]    _//////////_
class ResultAccurateView : UIView {
    var setObj = HmUnitSet()
    var graph = HtGraph()

    override func awakeFromNib() {
        print("\n\n\n ResultAccurateView : awakeFromNib")
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        graph.startDraw(UIGraphicsGetCurrentContext()!)
        // Text
        drawBreathTexts()
        // Center Circle.
        drawCircleGraph()
    }

    func drawCircleGraph() {
        let x:CGFloat = 229, y:CGFloat = 120

        let yellow = HmGraphSetting.inst.graphYello

        graph.drawQuaterArc(0, corX: x, corY: y, dia: 60, col: yellow.colorWithAlphaComponent(setObj.getPositionRatio(1)))
        graph.drawQuaterArc(1, corX: x, corY: y, dia: 60, col: yellow.colorWithAlphaComponent(setObj.getPositionRatio(2)))
        graph.drawQuaterArc(2, corX: x, corY: y, dia: 60, col: yellow.colorWithAlphaComponent(setObj.getPositionRatio(3)))
        graph.drawQuaterArc(3, corX: x, corY: y, dia: 60, col: yellow.colorWithAlphaComponent(setObj.getPositionRatio(4)))

        graph.drawCircle(x, corY: y, dia: 40, col: HmGraphSetting.inst.graphGreen)
    }

    func drawBreathTexts() {
        let font = UIFont(name: "Helvetica Neue", size: 55), fontPerc = UIFont(name: "Helvetica Neue", size: 40) // 65
        let rightStyle = NSMutableParagraphStyle(), paraStyle = NSMutableParagraphStyle()
        let percent = setObj.ccCorrectPositionRatioString, unit = "%", skew = 0.1
        rightStyle.alignment = .Right

        var attributes: NSDictionary = [
            NSForegroundColorAttributeName: HmGraphSetting.inst.graphGreen, NSParagraphStyleAttributeName: rightStyle,
            NSObliquenessAttributeName: skew,      NSFontAttributeName: font!  ]
        percent.drawInRect(CGRectMake(0, 10, 95.0, 80.0), withAttributes: attributes as? [String : AnyObject])
        //percent.drawInRect(CGRectMake(15, 10, 150.0, 80.0), withAttributes: attributes as? [String : AnyObject])
        attributes = [
            NSForegroundColorAttributeName: HmGraphSetting.inst.graphGreen, NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,      NSFontAttributeName: fontPerc!  ]

        //unit.drawInRect(CGRectMake(90, 30, 70.0, 80.0), withAttributes: attributes as? [String : AnyObject])
        unit.drawInRect(CGRectMake(98, 25, 40.0, 80.0), withAttributes: attributes as? [String : AnyObject])
    }
}
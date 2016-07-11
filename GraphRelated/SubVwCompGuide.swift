//
//  SubVwCompGuide.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2016. 3. 7..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation



// MARK:  압박 깊이. 첫번째 그래프의 글자..
class SubVwCompGuide : UIView { //
    var graph = HtGraph()

    override func drawRect(rect: CGRect)  {
        // 이완 필요   압박 부족   잘못된 위치
        let recoilNeeded = langStr.obj.recoil_needed, tooWeak = langStr.obj.too_weak,
        wrongPosi = langStr.obj.wrong_position
        // set the text color to dark gray
        let fieldColor: UIColor = UIColor.blackColor()
        // set the font to Helvetica Neue 18
        let fieldFont = UIFont(name: "Helvetica Neue", size: HmGraphSetting.inst.fontSizeSmallTitle)
        // set the line spacing to 6
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0

        // set the Obliqueness to 0.1
        let skew = 0
        let attributes: NSDictionary = [
            NSForegroundColorAttributeName: fieldColor,
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont!
        ]
        // 상, 하 노란 화살표 & X  표시..
        graph.drawArrow(15, arrowY: 15, size: 15, isUp: true, color: HmGraphSetting.inst.graphYello)
        graph.drawArrow(165, arrowY: 30, size: 15, isUp: false, color: HmGraphSetting.inst.graphYello)
        graph.drawX(315, arrowY: 15, size: 15, color: UIColor.grayColor())
        // 글자 쓰기
        recoilNeeded.drawInRect(CGRectMake(30, 10, 120, 20.0), withAttributes: attributes as? [String : AnyObject])
        tooWeak.drawInRect(CGRectMake(180, 10, 120.0, 20.0), withAttributes: attributes as? [String : AnyObject])
        wrongPosi.drawInRect(CGRectMake(330, 10, 120.0, 20.0), withAttributes: attributes as? [String : AnyObject])

        super.drawRect(rect)
    }
}

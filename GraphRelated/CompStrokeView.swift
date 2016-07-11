//
//  CompStrokeView.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2016. 3. 7..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation



//////////////////////////////////////////////////////////////////////     _//////////_     [      압박 그래프      ]    _//////////_
// MARK:  압박 깊이. 첫번째 그래프
class CompStrokeView : UIView { //
    var graph = GraphSubStroke()
    var strokeObj = HmUnitSet()

    var staX:CGFloat = 50, finX:CGFloat = 50, upY:CGFloat = 0, // 프레임의 최 상단..  0% 지점.
    loY:CGFloat = 0.8, redY:CGFloat = 0.78  // 0.65, 0.78 지점.. 5, 10 숫자 쓰는 부분.  나중에..

    override func awakeFromNib() {
        print("\n\n\n ResultDetailView : awakeFromNib")
        graph = GraphSubStroke(pThk: 10, xNum: 30, yNum: 3,
            pArea:CGRect(x: frame.width * 0.35, y: 2, width: frame.width * 0.55, height: frame.height))
        staX = 50; finX = frame.width - 50;

        // cc_weak_point : 58, cc_strong_point : 78

        upY = 10; //loY = frame.height * 0.65;  // 좌우로 50 여백.
        loY = 114// 125.5 // 64 > 125.2, 65 > 127.0 이니까..

        let distOfOne = 153 / 78.0

        print(" graphxx : \(frame.height)  \(upY)     \(loY)  ")

        loY = upY + CGFloat(Double(CC_WEAK_POINT) * distOfOne)

        print(" graphxx : \(frame.height)  \(upY)     \(loY)  \(upY + CGFloat(Double(100) * distOfOne))  ")

        redY = 163 //150  //  78 > 150.4  frame.height * 0.78
    }

    override func drawRect(rect: CGRect)  {
        graph.startDraw(UIGraphicsGetCurrentContext()!)
        graph.drawStroke(strokeObj) // 여기서 그릴것 같다.  스트로크 바... !!!!!

        drawGuideLine()  // 점선.
        let relax = langStr.obj.recoil, nomal = langStr.obj.good_depth, strong = langStr.obj.excessive

        // set the text color to dark gray
        let fieldColor: UIColor = HmGraphSetting.inst.graphGreen

        // set the font to Helvetica Neue 18
        let fieldFont = UIFont(name: "Helvetica Neue", size: HmGraphSetting.inst.fontSizeSmallTitle)

        // set the line spacing to 6
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0

        // set the Obliqueness to 0.1
        let skew = 0.1
        let attributes: NSDictionary = [
            NSForegroundColorAttributeName: fieldColor, NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew, NSFontAttributeName: fieldFont! ]

        let redAttb: NSDictionary = [ NSForegroundColorAttributeName: HmGraphSetting.inst.graphRed,
            NSParagraphStyleAttributeName: paraStyle, NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont! ]
        // 글자 쓰기..
        relax.drawInRect(CGRectMake(staX, upY, 100.0, 30.0), withAttributes: attributes as? [String : AnyObject])
        nomal.drawInRect(CGRectMake(staX, loY, 100.0, 30.0), withAttributes: attributes as? [String : AnyObject])
        strong.drawInRect(CGRectMake(staX, redY, 100.0, 30.0), withAttributes: redAttb as? [String : AnyObject])

        strokeCountNumber()

        super.drawRect(rect)
    }

    func strokeCountNumber() {
        let dotDia: CGFloat = 10, pY: CGFloat = 197, pitch: CGFloat = 14.08
        let font = UIFont(name: "Helvetica Neue", size: HmGraphSetting.inst.fontSizeSmallTitle)
        let paraStyle = NSMutableParagraphStyle()

        var nX: CGFloat = 269 // 그냥 이렇게 하자.
        for idx in 0...29 {
            if (idx % 5) == 4 {
                let str = "\(idx+1)"
                var coX = nX - dotDia * 0.5
                if idx > 6 { coX -= dotDia * 0.5 } // 10 같은 두자릿 수 처리
                let attributes: NSDictionary = [
                    NSForegroundColorAttributeName: HmGraphSetting.inst.graphText, NSParagraphStyleAttributeName: paraStyle,
                    NSObliquenessAttributeName: 0,      NSFontAttributeName: font!  ]

                if idx > 9 { coX = coX - dotDia * 0.5 }
                str.drawInRect(CGRectMake(coX, pY, 30.0, 30.0), withAttributes: attributes as? [String : AnyObject])
            }
            nX += pitch
        }
    }

    func drawGuideLine() { // 가이드 점선... 3개..
        var bezPath = UIBezierPath()
        //print("  grid y posi >>   \(upY)  \(loY)  \(redY)  ") // 10 123.8 163
        redY = 10 + (197 - 10) * CGFloat(CC_STRONG_POINT) / 100 // 빨간 점선
        loY = 10 + (197 - 10) * CGFloat(CC_WEAK_POINT) / 100  // 녹색 점선..

        bezPath.moveToPoint     (CGPoint(x: staX, y: upY))
        bezPath.addLineToPoint  (CGPoint(x: finX, y: upY))
        bezPath.moveToPoint     (CGPoint(x: staX, y: loY))
        bezPath.addLineToPoint  (CGPoint(x: finX, y: loY))
        HmGraphSetting.inst.graphGreen.setStroke() // 녹색 선.
        bezPath.lineWidth = 1
        let dash :[CGFloat] = [ 3, 2 ]
        bezPath.setLineDash(dash, count: 2, phase: 0)
        bezPath.stroke()

        bezPath = UIBezierPath()
        HmGraphSetting.inst.graphRed.setStroke()
        bezPath.moveToPoint     (CGPoint(x: staX, y: redY))
        bezPath.addLineToPoint  (CGPoint(x: finX, y: redY))
        bezPath.setLineDash(dash, count: 2, phase: 0)
        bezPath.stroke()
    }
}
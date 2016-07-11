//
//  CompressStrokeGraph.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2016. 1. 13..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation




class GraphSubStroke : HtGraph {  //CompressStrokeGraph : HtGraph {
    var thick: CGFloat = 2, arrowMargin:CGFloat = 12, pitch:CGFloat = 0, lineWidth:CGFloat = 0

    override init() {  super.init()  }
    convenience init(pThk: CGFloat, xNum: Int, yNum: Int, pArea: CGRect) {
        self.init()
        thick = pThk; numX = xNum; numY = yNum
        area = pArea
        pitch = (area?.width)! / CGFloat(numX)
        lineWidth = CGFloat(Int(pitch * 0.85))
        print(" HtVerticalGraph  ::  init     \((area?.size.width)!) X \((area?.size.height)!)  pitch : \(pitch)   lineWidth : \(lineWidth) ")
    }

    // X 표 그리기..   graph.drawX(315, arrowY: 15, size: 15, color: UIColor.grayColor())
    /// 압박 그래프 그리기.
    func drawStroke(obj: HmUnitSet) {
        hmStrokeObj = obj
        var startX = (area?.origin.x)! + pitch * 0.5 // 무시하자.. staX = dotAreaX1 (frame.width * 0.2) 이다.. + pitch * 0.5;
        startX = 269

        let y1 = (area?.origin.y)!
        let y2 = y1 + (area?.height)!
        let graphYa = y1 + 8, graphYb = y2 - 20 // y2 - 8 // 조금만 줄이자
        let redLineY: CGFloat = graphYa + (graphYb - graphYa) * CGFloat(CC_STRONG_POINT) / 100
        //print(" Count : \(hmStrokeObj.arrComprs.count)   graph : \(graphYa)   \(graphYb)")  // 이 값에 맞춰 그리드 라인을 그려야 함. 10 / 197

        for (ix, sObj) in hmStrokeObj.arrComprs.enumerate() {
            if 30 <= ix { break }
            var bezPath = UIBezierPath()
            var curCol = HmGraphSetting.inst.graphGreen
            let (yf, yt) = sObj.getStaEnd(graphYa, topo: graphYb), wid = lineWidth * 0.5

            // Wrong Position :  X mark
            if 0 < sObj.wPosiIdx {
                drawX(startX, arrowY: yf + 2, size: 12, color: UIColor.grayColor())
                drawX(startX, arrowY: graphYb * 0.6 + 2, size: 12, color: UIColor.grayColor())
                startX += pitch
                continue
            }

            if sObj.maxDepth < Int(CC_WEAK_POINT)    { // 이상 있는 놈들.  65
                curCol = HmGraphSetting.inst.graphYello
                drawArrow(startX, arrowY: yf + arrowMargin, size: 10, isUp: false, color: curCol)
            }
            if 20 <= sObj.recoilDepth { // 이상 있는 놈들.
                curCol = HmGraphSetting.inst.graphYello
                drawArrow(startX, arrowY: yt - arrowMargin, size: 10, isUp: true,  color: curCol)  // 화살표
            }
            if Int(CC_STRONG_POINT) < sObj.maxDepth { curCol = HmGraphSetting.inst.graphYello } // 85

            bezPath.moveToPoint     (CGPoint(x: startX, y: yf - wid)) // 아래
            bezPath.addLineToPoint  (CGPoint(x: startX, y: yt + wid)) // 위
            curCol.setStroke();   bezPath.lineWidth = lineWidth;  bezPath.lineCapStyle = CGLineCap.Round; bezPath.stroke()

            //print("   HtVerticalGraph :: drawStroke       압박 그래프 그리기   >> 최대값 : \(sObj.maxDepth)   리코일 : \(sObj.recoilDepth)  yf : \(yf)  wPosiIdx : \(sObj.wPosiIdx) ")

            if Int(CC_STRONG_POINT) < sObj.maxDepth {  // 85
                bezPath = UIBezierPath()
                curCol = HmGraphSetting.inst.graphRed
                //print("  val  \(yf - wid), total H : \(yf - 150.4), h : \(yf - 150.4) > 5.5 ? ")
                var h: CGFloat = 0 //redLineY: CGFloat = 163

                if wid < yf - redLineY { // 전체 키가 반지름 초과
                    bezPath.moveToPoint     (CGPoint(x: startX, y: yf - wid))
                    bezPath.addLineToPoint  (CGPoint(x: startX, y: redLineY))
                    curCol.setStroke();   bezPath.lineWidth = lineWidth;  bezPath.lineCapStyle = CGLineCap.Butt; bezPath.stroke()
                    h = 0
                } else {
                    h = wid - (yf - redLineY)
                }

                drawPartMoon(startX, cenY: yf - wid, rad: wid , h: h, col: curCol)
            }
            startX += pitch
        }
        
    }
    
}

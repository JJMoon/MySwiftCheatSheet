//
//  ResultSpeedView.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2016. 3. 7..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation


//////////////////////////////////////////////////////////////////////     _//////////_     [      ResultSpeedView : 속도 뷰..      ]    _//////////_
class ResultSpeedView : UIView {
    var graph = GraphSub3Dot()
    var strokeObj = HmUnitSet()

    override func awakeFromNib() {
        print("\n\n\n ResultSpeedView : awakeFromNib")
        graph = GraphSub3Dot(pArea: CGRect(x: 50, y: 0, width: frame.width - 100, height: frame.height),
            xNum: 30, yNum: 3, dotDia: 10, midColor: HmGraphSetting.inst.graphAreaTransparentGreen,
            dotX1: frame.width * 0.35, dotX2: frame.width * 0.9)
    }

    override func drawRect(rect: CGRect) {
        print("\n\n\n ResultSpeedView : drawRect      ")
        super.drawRect(rect)
        graph.startDraw(UIGraphicsGetCurrentContext()!)
        graph.drawSpeedElements(strokeObj)
    }
}

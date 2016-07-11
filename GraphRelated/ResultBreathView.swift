//
//  GraphViews.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2015. 12. 2..
//  Copyright © 2015년 IMLab. All rights reserved.
//

import Foundation




//////////////////////////////////////////////////////////////////////     _//////////_     [      ResultBreathView : 호흡 뷰..      ]    _//////////_
class ResultBreathView : UIView {
    var graph = GraphSub3Dot()
    var strokeObj = HmUnitSet()
    
    override func awakeFromNib() {
        print("\n\n\n ResultSpeedView : awakeFromNib")
        graph = GraphSub3Dot(pArea: CGRect(x: 50, y: 0, width: frame.width - 50, height: frame.height),
            xNum: 30, yNum: 3, dotDia: 10, midColor: HmGraphSetting.inst.graphAreaTransparentGreen,
            dotX1: frame.width * 0.2, dotX2: frame.width * 0.9)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        graph.startDraw(UIGraphicsGetCurrentContext()!)
        graph.drawBreathElements(strokeObj)
    }
}


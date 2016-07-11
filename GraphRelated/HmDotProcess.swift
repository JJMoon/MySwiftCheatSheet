//
//  HmDotProcess.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2016. 1. 19..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation

class HmDotProcess: UIView {
    var log = HtLog(cName: "HmDotProcess")
    var timer = NSTimer()

    var progress: CGFloat = 0
    var sta: CGFloat = 0.25, end: CGFloat = 0.65, num: Int = 5, size: CGFloat = 8, redNum = 1
    var outColor = colorGreyBright, dotColor = UIColor.redColor()

    var graph = HtGraph()

    override func awakeFromNib() {
        log.printThisFNC("awakeFromNib", comment: "")
        self.backgroundColor = colorWhiteAlpha80
        layer.cornerRadius = 20
        timer = NSTimer.scheduledTimerWithTimeInterval(0.7, // second
            target:self, selector: Selector("update"),
            userInfo: nil, repeats: true)
    }

    override func drawRect(rect: CGRect) {
        //log.printThisFNC("drawRect", comment: "")
        super.drawRect(rect)

        graph.startDraw(UIGraphicsGetCurrentContext()!)

        let wid = frame.size.width, pitch = (wid * (end - sta)) / CGFloat(num - 1), y = frame.size.height * 0.5 - 30 // Xib 하고 30 하고 맞춰야 함..
        var xCo = wid * sta
        for _ in 1...num {
            graph.drawCircleAt(xCo, corY: y, dia: size + 2, col: outColor)
            xCo += pitch
        }

        xCo = wid * sta + CGFloat(redNum) * pitch
        graph.drawCircleAt(xCo, corY: y, dia: size, col: dotColor)

        let lineY = 0.75 * frame.size.height, prgX = (0.21 + 0.6 * progress) * wid // 0.2 0.8 사이의 중간.
        graph.drawLine(0.2 * wid, fromy: lineY, tox: prgX, toy: lineY, wid: 8, col: colorBttnDarkGreen, capStyle: .Round)



//        for _ in 1...redNum {
//            graph.drawCircleAt(xCo, corY: y, dia: size, col: dotColor)
//            xCo += pitch
//        }

    }

    func update() {
        setNeedsDisplay()
        if redNum == 4 {
            redNum = 0
            //progress = 0.1
        }
        else {
            redNum++;
            //progress += 0.2
        }
    }
}
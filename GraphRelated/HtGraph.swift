//
//  HtGraph.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2016. 1. 12..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation



class HtGraph : NSObject {
    var ctx: CGContextRef?
    var area: CGRect?
    var numX: Int = 10, numY: Int = 10

    var hmStrokeObj: HmUnitSet = HmUnitSet()

    override init() {  super.init()  }
    convenience init(xNum: Int, yNum: Int, pArea: CGRect) {
        self.init()
        numX = xNum; numY = yNum
        area = pArea
    }

    func startDraw(contxt: CGContextRef) {
        ctx = contxt
    }

    func drawCircle(corX : CGFloat, corY : CGFloat, dia: CGFloat, col: UIColor) {
        col.setFill()
        CGContextMoveToPoint(ctx, corX, corY)
        let theRect = CGRect(x: Int(corX - dia * 0.5), y: Int(corY - dia * 0.5), width: Int(dia), height: Int(dia))
        CGContextAddEllipseInRect(ctx, theRect)
        CGContextFillEllipseInRect(ctx, theRect)
    }


    func drawCircleAt(corX : CGFloat, corY : CGFloat, dia: CGFloat, col: UIColor) {
        col.setFill()
        CGContextMoveToPoint(ctx, corX, corY)
        let theRect = CGRect(x: corX - dia * 0.5, y: corY - dia * 0.5, width: dia, height: dia)
        CGContextAddEllipseInRect(ctx, theRect)
        CGContextFillEllipseInRect(ctx, theRect)
    }

    func drawPartMoon(cenX : CGFloat, cenY : CGFloat, rad: CGFloat, h: CGFloat, col: UIColor) {
        // cen : 원의 중심 좌표, r, h: 중심에서의 거리. < r
        col.setFill()
        CGContextBeginPath(ctx);
        let theta: CGFloat = acos(h/rad), pi4 = CGFloat(M_PI/2), ang1: CGFloat = pi4 - theta, ang2: CGFloat = pi4 + theta

        print(" theta : \(theta)")

        CGContextAddArc(ctx, cenX, cenY, rad, ang1, ang2, 0)
        CGContextClosePath(ctx)
        CGContextSetFillColorWithColor(ctx, col.CGColor)
        CGContextDrawPath(ctx, CGPathDrawingMode.Fill);
    }

    func drawQuaterArc(direct: Int, corX : CGFloat, corY : CGFloat, dia: CGFloat, col: UIColor) {
        col.setFill()
        var staAng:CGFloat = 0, finAng:CGFloat = 0, deg45:CGFloat = CGFloat(M_PI * 0.25)
        switch direct {  // 0 : North, 1 : East, 2 : South, 3 : West
        case 0:     staAng = -deg45 * 3;    finAng = -deg45
        case 1:     staAng = -deg45;        finAng = deg45
        case 2:     staAng = deg45;         finAng = deg45 * 3
        default:    staAng = deg45 * 3;     finAng = deg45 * 5
        }
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, corX, corY);

        //let theRect = CGRect(x: Int(corX - dia * 0.5), y: Int(corY - dia * 0.5), width: Int(dia), height: Int(dia))
        CGContextAddArc(ctx, corX, corY, dia, staAng, finAng, 0)
        CGContextClosePath(ctx)
        CGContextSetFillColorWithColor(ctx, col.CGColor)
        //CGContextFillEllipseInRect(ctx, theRect)

        // draw the path
        CGContextDrawPath(ctx, CGPathDrawingMode.Fill);
    }

    func drawLine(fromx: CGFloat, fromy: CGFloat, tox: CGFloat, toy: CGFloat, wid: CGFloat, col: UIColor, capStyle: CGLineCap) {
        let bezPath = UIBezierPath()
        bezPath.moveToPoint(CGPoint(x: fromx, y: fromy))
        bezPath.addLineToPoint(CGPoint(x: tox, y: toy))
        bezPath.lineWidth = wid
        col.setStroke()
        bezPath.lineCapStyle = capStyle
        bezPath.stroke()
    }

    func drawX(arrowX : CGFloat, arrowY : CGFloat, size: CGFloat, color: UIColor) {
        let halfOfSize = size * 0.5
        let bezPath = UIBezierPath()
        let xLeft = arrowX - halfOfSize, xRigt = arrowX + halfOfSize
        let yUp = arrowY, yDn = arrowY + size

        bezPath.moveToPoint(CGPoint(x: xLeft, y: yUp))
        bezPath.addLineToPoint(CGPoint(x: xRigt, y: yDn))
        bezPath.moveToPoint(CGPoint(x: xLeft, y: yDn))
        bezPath.addLineToPoint(CGPoint(x: xRigt, y: yUp))
        bezPath.closePath()
        bezPath.lineWidth = 1
        color.setStroke();      bezPath.stroke()
        //color.setFill();      bezPath.fill()
    }

    func drawArrow(arrowX : CGFloat, arrowY : CGFloat, size: CGFloat, isUp : Bool, color: UIColor) {
        let halfOfSize = size * 0.5
        var deltaY = halfOfSize, endY = size
        if !isUp {            deltaY *= -1; endY *= -1        }
        let bezPath = UIBezierPath()
        let xLeft = arrowX - halfOfSize * 0.5
        let xRigt = arrowX + halfOfSize * 0.5
        bezPath.moveToPoint(CGPoint(x: arrowX, y: arrowY))
        bezPath.addLineToPoint(CGPoint(x: arrowX - halfOfSize, y: arrowY + deltaY))
        bezPath.addLineToPoint(CGPoint(x: xLeft, y: arrowY + deltaY))
        bezPath.addLineToPoint(CGPoint(x: xLeft, y: arrowY + endY))
        bezPath.addLineToPoint(CGPoint(x: xRigt, y: arrowY + endY))
        bezPath.addLineToPoint(CGPoint(x: xRigt, y: arrowY + deltaY))
        bezPath.addLineToPoint(CGPoint(x: arrowX + halfOfSize, y: arrowY + deltaY))
        bezPath.closePath()
        bezPath.lineWidth = 1
        //color.setStroke();      bezPath.stroke()
        color.setFill();        bezPath.fill()
    }
}


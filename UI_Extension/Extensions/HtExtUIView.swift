//
//  HtExtUIView.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2015. 11. 17..
//  Copyright © 2015년 IMLab. All rights reserved.
//

import Foundation
import UIKit

// AutoLayout 제한 설정 메모..
// myView.heightAnchor.constraintEqualToAnchor(myView.widthAnchor, multiplier: 2.0)  Aspect Ration 1:2 로 하기..


extension NSLayoutConstraint {

    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {

        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)

        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        newConstraint.isActive = true

        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}


public extension UIView {

    func cornerRad(rad: CGFloat) { // 라벨의 경우 masksToBound 를 해야 함..
        layer.cornerRadius = rad
        layer.masksToBounds = true
    }


    func setHeightWith(newHeight: CGFloat) {
        self.frame.size = CGSize(width: self.frame.size.width, height: newHeight)
    }

    func setBorder(wid: CGFloat, rad: CGFloat, borderCol: UIColor, bgCol: UIColor?) {
        self.layer.cornerRadius = rad
        self.layer.borderWidth = wid
        self.layer.borderColor = borderCol.cgColor
        if bgCol != nil { self.backgroundColor = bgCol! }
    }

    func getConstAspectRatio(hOverw: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: self,
                                       attribute: NSLayoutAttribute.width, multiplier: hOverw, constant: 0)
    }

    func getConstCenterX(target: UIView, delta: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: .equal,
                                       toItem: target, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: delta)
    }
    func getConstCenterY(target: UIView, delta: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: .equal,
                                       toItem: target, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: delta)
    }

    func getConstSize(width: CGFloat, height: CGFloat) -> [ NSLayoutConstraint ] {
        return [ NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: .equal,
            toItem: nil, attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1, constant: width),
                 NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: .equal,
                    toItem: nil, attribute: NSLayoutAttribute.notAnAttribute,
                    multiplier: 1, constant: height) ]
    }


    func addSubViewVertCenter(subVw: UIView?, frY: CGFloat, toY: CGFloat, marginX: CGFloat, nth: Int, ea: Int, margin: CGFloat) -> UIView? {
        var subVw = subVw
        if ea <= nth {
            print("\n\n\n\n\n  HtExtUIView :: addSubViewVertCenter Error  !!!!  \t\t ea <= nth  \n\n\n\n\n")
            return nil
        }

        if subVw == nil { subVw = UIView() }

        var space = (toY - frY) - margin

        if 1 < ea { space = space / CGFloat(ea) }

        print("  addSubViewVertCenter   space \(space) ")

        let pY = frY + margin + CGFloat(nth) * (space)
        subVw?.frame.origin = CGPoint(x: marginX, y: pY)
        subVw?.frame.size = CGSize(width: frame.size.width - marginX, height: space)

        //print("  origin : \(subVw.frame.origin)   size : \(subVw.frame.size) ")

        addSubview(subVw!)
        return subVw
    }

    func addSubViewCentering(subVw: UIView, size: CGSize, atY: CGFloat, nth: Int, ea: Int, margin: CGFloat) {
        if ea <= nth {
            print("\n\n\n\n\n  HtExtUIView :: addSubViewCentering Error  !!!!  \t\t ea <= nth  \n\n\n\n\n")
            return
        }
        var space = frame.size.width - (CGFloat(ea) * size.width) - (2 * margin)

        if 1 < ea { space = space / (CGFloat(ea) - 1) }

        let pX = margin + CGFloat(nth) * (size.width + space)
        subVw.frame.origin = CGPoint(x: pX, y: atY)
        subVw.frame.size = size
        addSubview(subVw)
    }

    func rotate360Degrees(duration: CFTimeInterval = 1.0, repeatCnt: Float, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.repeatCount = repeatCnt
        rotateAnimation.fromValue = CGFloat(2 * Double.pi)
        rotateAnimation.toValue = 0.0
        rotateAnimation.duration = duration
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as! CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }

    func hideMe() {
        self.isHidden = true
    }

    func showMe() {
        self.isHidden = false
    }

    func show_다음이_참이면(boolVal: Bool?) {
        self.isHidden = !boolVal!
    }
}

public extension UIButton {
    func alignCenter() {
        self.titleLabel?.textAlignment = .center
    }

    func setTtitleAccordingTo(bVar: Bool, trueTxt: String, falseTxt: String) {
        if bVar {
            self.setTitle(trueTxt, for: .normal)
        } else {
            self.setTitle(falseTxt, for: .normal)
        }
    }

    func setImageAccordingTo(bVar: Bool, trueImg: String, falseImg: String) {
        if bVar {
            self.setImage(UIImage(named: trueImg), for: .normal)
        } else {
            self.setImage(UIImage(named: falseImg), for: .normal)
        }
    }

    func localizeSizeAlignment(lineN : Int, topSpace: Int = 3, btmSpace: Int = 3) { // 버튼 텍스트 조절, 중앙, multi line...
        self.translatesAutoresizingMaskIntoConstraints = false // Xcode 가 기본으로 덧붙이는 제한을 막는다.
        let viewDict : [String : AnyObject] = ["Vw" : self.titleLabel!]
        let formatStr = "V:|-\(topSpace)-[Vw]-\(btmSpace)-|"
        let cons = NSLayoutConstraint.constraints(withVisualFormat: formatStr, options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: viewDict)
        self.addConstraints(cons)

        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.numberOfLines = lineN
        self.titleLabel?.alignCenter()
    }

    func activate() {
        self.isEnabled = true
    }

    func deactivate() {
        self.isEnabled = false
    }
}

public extension UILabel {
    func alignCenter() {
        self.textAlignment = .center
    }

    func setColorAccord(boolVal: Bool, tColor: UIColor, fColor: UIColor) {
        if boolVal { self.textColor = tColor }
        else { self.textColor = fColor }
    }
}

public extension UITextField {
    func getInt(defaultVal: Int) -> Int {
        if let intNum = NumberFormatter().number(from: text!) {
            return  intNum.intValue
        } else {
            return defaultVal
        }
    }
}

public extension NSArray {
    func getJson() -> String {
        var rStr = ""
        for obj in self {
            rStr = "\(rStr), \(obj)"
        }
        return "[ \(rStr) ]"
    }
}

//  "timestamp": "2015-11-02 21:52:43",

//extension NSDate {
//    struct Date {
//        static let formatter = DateFormatter()
//    }
//    var formattedT: String {
//        Date.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
//        Date.formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
//        Date.formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
//        Date.formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//        return Date.formatter.stringFromDate(self)
//    }
//
//    func formatFromOption(opt: Int) -> String {
//        var formt = "yyyy-MM-dd HH:mm:ss"
//        switch opt {
//        case 0:
//            formt = "yyyy/MM/dd"
//        case 1:
//            formt = "dd/MM/yyyy"
//        case 2:
//            formt = "MM/dd/yyyy"
//        default:
//            formt = "yyyy/MM/dd"
//        }
//
//        Date.formatter.dateFormat = formt
//        //Date.formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
//        Date.formatter.timeZone = NSTimeZone.localTimeZone()
//        Date.formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
//        Date.formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//        return Date.formatter.stringFromDate(self)
//    }
//    
//    var formatYYMMDDspaceTime: String {
//        Date.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        //Date.formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
//        Date.formatter.timeZone = NSTimeZone.local
//        Date.formatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601)! as Calendar!
//        Date.formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
//        return Date.formatter.stringFromDate(self)
//    }
//
//}

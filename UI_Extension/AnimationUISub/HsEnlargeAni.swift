//
//  HsEnlargeAni.swift
//  HS Monitor
//
//  Created by Jongwoo Moon on 2016. 7. 25..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation
import UIKit

protocol someProtocol {

    func sampleFUnc()
}


protocol PrtclEnlargeView {
    var targetView: UIView? { get set }

    var tarPoint: CGPoint? { get set }
    var baseOrigin: CGPoint? { get set }
    var scal : CGFloat { get set }

    /// 임시로 생성하는 뷰, 버튼
    var bgView: UIView? { get set } // 백그라운드의 반투명 버튼
    var bttnClose: UIButton? { get set } // 화면 닫는 투명 버튼
    var enlargeClsr: ((Void) -> Void)? { get set }

    mutating func animation()
}

extension PrtclEnlargeView  where Self: UIViewController {
    mutating func animation() {

        //print("  there here")

        if baseOrigin == nil {
            print("  Enlarge ")
            self.targetView!.contentMode = UIViewContentMode.Redraw
            baseOrigin = targetView!.center
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 3,
                                       options: [   ],
                                       animations: {
                                        self.targetView!.center = self.tarPoint!
                                        self.targetView!.transform = CGAffineTransformMakeScale(self.scal, self.scal)})
            { [] (finished: Bool) in
                print("  finished >> ")
            }

            bgView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.mainScreen().bounds.size))
            bgView!.backgroundColor = colHalfTransGray

            //  view.addSubview(bgView!)  백그라운드 뷰 없다....
            self.view.bringSubviewToFront(targetView!)
            //view.addSubview(bttnClose!)

            if (enlargeClsr != nil) { enlargeClsr!() }

        } else {
            print("  Shrink  ")
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 3,
                                       options: [   ],
                                       animations: {
                                        self.targetView!.transform = CGAffineTransformIdentity
                                        self.targetView!.center = self.baseOrigin!
                                        self.targetView!.setNeedsLayout()
                                        self.targetView!.layoutIfNeeded()
                })
            { [] (finished: Bool) in
                self.targetView!.setNeedsLayout()
                self.targetView!.layoutIfNeeded()
                self.baseOrigin = nil
            }

            bgView?.removeFromSuperview()
            bttnClose?.removeFromSuperview()
        }
        
        
    }

    mutating func shrinkAction(sender: UIButton!) {
        animation()

    }
    
}
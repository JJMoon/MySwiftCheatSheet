//
//  TrainerSignalView.swift
//  Trainer
//
//  Created by Jongwoo Moon on 2016. 4. 15..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation


class TrainerSignalView: UIView {
    var log = HtLog(cName: "TrainerSignalView")

    var imgSafe = UIImageView(image: UIImage(named: "lc_checkdanger_gray")) // 325 x 239
    var imgResp = UIImageView(image: UIImage(named: "lc_response_gray"))
    var imgAway = UIImageView(image: UIImage(named: "lc_airway_gray"))
    var imgChkB = UIImageView(image: UIImage(named: "lc_checkbreath_gray"))
    var imgEmer = UIImageView(image: UIImage(named: "lc_emergency_gray"))
    var imgCprp = UIImageView(image: UIImage(named: "lc_cpr_gray"))
    var imgAEDp = UIImageView(image: UIImage(named: "lc_aed_gray"))
    var imgPuls = UIImageView(image: UIImage(named: "lc_pulsecheck_gray"))

    var lblSafe = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
    var lblResp = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
    var lblAway = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
    var lblChkB = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
    var lblEmer = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
    var lblCprp = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
    var lblAEDp = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
    var lblPuls = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))

    var lblExplain = UILabel(frame: CGRect(x: 0, y: 0, width: 1000, height: 40))

    var imgs = [UIImageView](), imgReds = [String](), imgGrys = [String]()
    var lbls = [UILabel]()
    var lblTexts = [String]()

    var superVw: UIView?

    var isDoctor = true //////   ///////////                            나중에 지울 것 ......   >>>>  ..
    var blinkAni = CABasicAnimation(), blinkNum = 2

    func setArrays() {
        imgs = [ imgResp, imgEmer, imgCprp, imgAEDp ] // checkpulse 가 가운데..
        lbls = [ lblResp, lblEmer, lblCprp, lblAEDp ]
        lblTexts = [ langStr.obj.response, langStr.obj.emergency, langStr.obj.cpr, langStr.obj.aed ]
        imgGrys = [ "lc_response_gray", "lc_emergency_gray", "lc_cpr_gray", "lc_aed_gray" ]
        imgReds = [ "lc_response_red", "lc_emergency_red", "lc_cpr_red", "lc_aed_red" ]

        if cprProtoN.theVal == 0 && isDoctor {
            imgs = [ imgResp, imgEmer, imgPuls, imgCprp, imgAEDp ] // checkpulse 가 가운데..
            lbls = [ lblResp, lblEmer, lblPuls, lblCprp, lblAEDp ]
            lblTexts = [ langStr.obj.response, langStr.obj.emergency, langStr.obj.check_pulse, langStr.obj.cpr, langStr.obj.aed ]
            imgGrys = [ "lc_response_gray", "lc_emergency_gray", "lc_pulsecheck_gray", "lc_cpr_gray", "lc_aed_gray" ]
            imgReds = [ "lc_response_red", "lc_emergency_red", "lc_pulsecheck_red", "lc_cpr_red", "lc_aed_red" ]
        }

        if cprProtoN.theVal == 1 {
            imgs = [ imgSafe, imgResp,   imgAway, imgChkB, imgEmer, imgCprp, imgAEDp ]
            lbls = [ lblSafe, lblResp,   lblEmer, lblAway, lblChkB, lblCprp, lblAEDp ]
            lblTexts = [ langStr.obj.check_danger_info_title, langStr.obj.response,
                         langStr.obj.open_airway_info_title, langStr.obj.check_breath_info_title, langStr.obj.emergency,
                         langStr.obj.cpr, langStr.obj.aed ]
            imgGrys = [ "lc_checkdanger_gray", "lc_response_gray", "lc_airway_gray", "lc_checkbreath_gray", "lc_emergency_gray", "lc_cpr_gray", "lc_aed_gray" ]
            imgReds = [ "lc_checkdanger_red", "lc_response_red", "lc_airway_red", "lc_checkbreath_red", "lc_emergency_red", "lc_cpr_red", "lc_aed_red" ]

        } else if cprProtoN.theVal == 2 {
            imgs = [ imgSafe, imgResp,   imgAway, imgChkB, imgEmer, imgCprp, imgAEDp ]
            lbls = [ lblSafe, lblResp,   lblEmer, lblAway, lblChkB, lblCprp, lblAEDp ]
            lblTexts = [ langStr.obj.check_danger_info_title, langStr.obj.response,
                         langStr.obj.emergency, langStr.obj.open_airway_info_title, langStr.obj.check_breath_info_title,
                         langStr.obj.cpr, langStr.obj.aed ]
            imgGrys = [ "lc_checkdanger_gray", "lc_response_gray", "lc_emergency_gray", "lc_airway_gray", "lc_checkbreath_gray", "lc_cpr_gray", "lc_aed_gray" ]
            imgReds = [ "lc_checkdanger_red", "lc_response_red", "lc_emergency_red", "lc_airway_red", "lc_checkbreath_red", "lc_cpr_red", "lc_aed_red" ]
        }
    }

    func setERCprotocol(superV: UIView) {
        superVw = superV
        setArrays()
        setAnimation()

        let labelOffsetY: CGFloat = 17, labelOffsetX: CGFloat = -16

        for img in imgs {
            img.translatesAutoresizingMaskIntoConstraints = false
            addSubview(img)
            addConstraint(NSLayoutConstraint.init(item: img, attribute: NSLayoutAttribute.Width,
                relatedBy: .Equal, toItem: img, attribute: .Height, multiplier: 325.0/239.0, constant: 0))
            addConstraint(NSLayoutConstraint.init(item: img, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal,
                toItem: self, attribute: .CenterY, multiplier: 1.0, constant: labelOffsetY))
        }

        let viewsDictionary = [ "safe": imgSafe, "resp": imgResp, "away": imgAway, "chkb": imgChkB,
                                "emer": imgEmer, "cprp": imgCprp, "aedp": imgAEDp, "puls": imgPuls ]
        let metricsDictionary = [ "imgWidt": 130.0, "imgHght": 100.0, "lblHght": 30.0, "spcH": 5 ] // 전체 폭은 130 * 7 >> 910..
        var horConstraintString = "H:|[resp(imgWidt)]-spcH-[emer(imgWidt)]-spcH-[cprp(imgWidt)]-spcH-[aedp(imgWidt)]"
        if cprProtoN.theVal == 0 && isDoctor {
            horConstraintString = "H:|[resp(imgWidt)]-spcH-[emer(imgWidt)]-spcH-[puls(imgWidt)]-spcH-[cprp(imgWidt)]-spcH-[aedp(imgWidt)]"
        }
        if cprProtoN.theVal == 1 {
            horConstraintString = "H:|-10-[safe(imgWidt)]-spcH-[resp(imgWidt)]-spcH-[away(imgWidt)]-spcH-[chkb(imgWidt)]-spcH-[emer(imgWidt)]-spcH-[cprp(imgWidt)]-spcH-[aedp(imgWidt)]"
        } else if cprProtoN.theVal == 2 {
            horConstraintString = "H:|-10-[safe(imgWidt)]-spcH-[resp(imgWidt)]-spcH-[emer(imgWidt)]-spcH-[away(imgWidt)]-spcH-[chkb(imgWidt)]-spcH-[cprp(imgWidt)]-spcH-[aedp(imgWidt)]"
        }

        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(horConstraintString,
                                                                    options: NSLayoutFormatOptions.AlignAllCenterY,
                                                                    metrics: metricsDictionary, views: viewsDictionary))
        // Labels...
        for (ix, lb) in lbls.enumerate() {
            lb.translatesAutoresizingMaskIntoConstraints = false

            addSubview(lb)
            addConstraint(NSLayoutConstraint.init(item: lb, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal,
                toItem: imgs[ix], attribute: .CenterY, multiplier: 1.0, constant: labelOffsetY))
            addConstraint(NSLayoutConstraint.init(item: lb, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal,
                toItem: imgs[ix], attribute: .CenterX, multiplier: 1.0, constant: labelOffsetX))
            addConstraint(NSLayoutConstraint.init(item: lb, attribute: NSLayoutAttribute.Width, relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 78)) // 라벨 폭..
            addConstraint(NSLayoutConstraint.init(item: lb, attribute: NSLayoutAttribute.Height, relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 35))

            lb.font = UIFont.systemFontOfSize(15) // (name: "System", size: 8)
            lb.text = lblTexts[ix]
            lb.adjustsFontSizeToFitWidth = true;             lb.lineBreakMode = .ByClipping
            lb.numberOfLines = 0;         lb.minimumScaleFactor = 0.5
            lb.alignCenter();             lb.sizeToFit()
        }

//
//        //  설명 라벨..
////        lblExplain.showMe()
//        lblExplain.translatesAutoresizingMaskIntoConstraints = false
//        lblExplain.text = langStr.obj.press_sensor_pad
//        lblExplain.textColor = UIColor.whiteColor()
//        lblExplain.font = UIFont.systemFontOfSize(25)
//        lblExplain.adjustsFontSizeToFitWidth = true;
//        lblExplain.minimumScaleFactor = 0.5
//        lblExplain.alignCenter()
//        lblExplain.sizeToFit()
//
//        addSubview(lblExplain)
//
//        print("  self.view>>>  \(self.frame.origin.x)    \(self.frame.size.width)") // 100, 900
////
//        addConstraint(NSLayoutConstraint.init(item: lblExplain, attribute: NSLayoutAttribute.Width, relatedBy: .Equal,
//            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 1000)) // 라벨 폭..
//        addConstraint(NSLayoutConstraint.init(item: lblExplain, attribute: NSLayoutAttribute.Height, relatedBy: .Equal,
//            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 35))
//        addConstraint(NSLayoutConstraint.init(item: lblExplain, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal,
//            toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 100))
//        addConstraint(NSLayoutConstraint.init(item: lblExplain, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal,
//            toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0))
//
//
//        print("  lblExplain >>>  \(lblExplain.frame.origin.x)    \(lblExplain.frame.size.width) ")
    }

    func printLabelPosition() {
        print("  printLabelPosition  >>>  \(lblExplain.frame.origin.x)    \(lblExplain.frame.size.width) ")
    }

    func setAnimation() {
        blinkAni = CABasicAnimation.init(keyPath: "opacity")
        blinkAni.fromValue = 1.0
        blinkAni.toValue = 0.1 //    [blinkAni setToValue:[NSNumber numberWithFloat:0.1]];
        blinkAni.duration = 0.7 //         [blinkAni setDuration:0.7f];
        blinkAni.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //        [blinkAni setTimingFunction:[CAMediaTimingFunction
        //        functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        blinkAni.autoreverses = true //         [blinkAni setAutoreverses:YES];
        blinkAni.repeatCount = 20000  //         [blinkAni setRepeatCount:200];

        blinkNum = 2
        if cprProtoN.theVal == 0 && isDoctor {
            blinkNum = 3
        }
        if 0 < cprProtoN.theVal {
            blinkNum = 5
        }

        for (i, img) in imgs.enumerate() {
            if i == blinkNum { break }
            img.image = UIImage(named: imgReds[i])
            img.layer.addAnimation(blinkAni, forKey: "opacity")
            lbls[i].layer.addAnimation(blinkAni, forKey: "opacity")
            lbls[i].textColor = UIColor.redColor()
        }
    }

    func setFinalAnimation() {

        lblExplain.hideMe()

        for (i, img) in imgs.enumerate() {
            if i <= blinkNum {
                img.image = UIImage(named: imgGrys[i])
                img.layer.removeAllAnimations()
                lbls[i].layer.removeAllAnimations()
                lbls[i].textColor = UIColor.grayColor()
            } else {
                img.image = UIImage(named: imgReds[i])
                img.layer.addAnimation(blinkAni, forKey: "opacity")
                lbls[i].layer.addAnimation(blinkAni, forKey: "opacity")
                lbls[i].textColor = UIColor.redColor()
            }

        }
    }
}



////addConstraint(NSLayoutConstraint.init(item: lblSafe, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: imgSafe, attribute: .CenterY, multiplier: 1.0, constant: 0))


////        let view1_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:[view1(50)]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)

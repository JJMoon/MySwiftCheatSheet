//
//  OperationSubViews.swift
//  heartisense
//
//  Created by Jongwoo Moon on 2015. 10. 27..
//  Copyright © 2015년 gyuchan. All rights reserved.
//

import Foundation

import UIKit

class HovSignalView : UIView {
    @IBOutlet weak var imgResponse: UIImageView!  // CPR
    @IBOutlet weak var imgEmergency: UIImageView!
    @IBOutlet weak var imgPulse: UIImageView! // Response
    @IBOutlet weak var imgCPR: UIImageView! // Pulse
    @IBOutlet weak var imgAED: UIImageView!
    
    @IBOutlet weak var lblResponse: UILabel!
    @IBOutlet weak var lblEmergency: UILabel!
    @IBOutlet weak var lblPulse: UILabel!
    @IBOutlet weak var lblCPR: UILabel!
    @IBOutlet weak var lblAED: UILabel!
    
    @IBOutlet weak var labelInstruction: UILabel!
    var blinkAni = CABasicAnimation()

    func viewDidLoad() {
        lblResponse.text = langStr.obj.response   // 센터 신호등 라벨 세팅.
        lblEmergency.text = langStr.obj.emergency
        lblPulse.text =  langStr.obj.check_pulse
        lblCPR.text = langStr.obj.cpr
        lblAED.text = langStr.obj.aed
        
        blinkAni = CABasicAnimation.init(keyPath: "opacity")
        blinkAni.fromValue = 1.0 //  [blinkAni setFromValue:[NSNumber numberWithFloat:1.0]];
        blinkAni.toValue = 0.1 //    [blinkAni setToValue:[NSNumber numberWithFloat:0.1]];
        blinkAni.duration = 0.7 //         [blinkAni setDuration:0.7f];
        blinkAni.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        [blinkAni setTimingFunction:[CAMediaTimingFunction
//        functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        blinkAni.autoreverses = true //         [blinkAni setAutoreverses:YES];
        blinkAni.repeatCount = 200  //         [blinkAni setRepeatCount:200];
    }
    
    func setFirst() {
        labelInstruction.hidden = false
        labelInstruction.text = langStr.obj.press_sensor_pad
        
        self.hidden = false
        imgAED.layer.removeAllAnimations()
        lblAED.layer.removeAllAnimations() // 라벨도 깜빡거려야 함..
        lblResponse.layer.addAnimation(blinkAni, forKey: "opacity")
        lblEmergency.layer.addAnimation(blinkAni, forKey: "opacity")
        lblPulse.layer.addAnimation(blinkAni, forKey: "opacity")
        imgResponse.layer.addAnimation(blinkAni, forKey: "opacity")
        imgEmergency.layer.addAnimation(blinkAni, forKey: "opacity")
        imgPulse.layer.addAnimation(blinkAni, forKey: "opacity")
        
        lblResponse.textColor = UIColor.redColor()
        lblEmergency.textColor = UIColor.redColor()
        lblPulse.textColor = UIColor.redColor()
        lblCPR.textColor = UIColor.grayColor()
        lblAED.textColor = UIColor.grayColor()
        
        imgResponse.image = UIImage(named: "lc_response_red")
        imgEmergency.image = UIImage(named: "lc_emergency_red1")
        imgPulse.image = UIImage(named: "lc_pulsecheck_red")
        imgCPR.image = UIImage(named: "lc_cpr2_gray")
        imgAED.image = UIImage(named: "lc_aed_gray")
    }
    
    func setFinal() {
        //print("\n\n\n\n\n   HovSignalView  ::  setFinal   \n\n\n\n\n ")
        labelInstruction.hidden = true
        self.hidden = false
        imgResponse.layer.removeAllAnimations()
        imgEmergency.layer.removeAllAnimations()
        imgPulse.layer.removeAllAnimations()
        lblResponse.layer.removeAllAnimations()
        lblEmergency.layer.removeAllAnimations()
        lblPulse.layer.removeAllAnimations()

        imgAED.layer.addAnimation(blinkAni, forKey: "opacity")
        lblAED.layer.addAnimation(blinkAni, forKey: "opacity")

        imgResponse.image = UIImage(named: "lc_response_gray")
        imgEmergency.image = UIImage(named: "lc_emergency_gray1")
        imgPulse.image = UIImage(named: "lc_pulsecheck_gray")
        imgCPR.image = UIImage(named: "lc_cpr2_gray")
        imgAED.image = UIImage(named: "lc_aed_red")

        lblResponse.textColor = UIColor.grayColor()
        lblEmergency.textColor = UIColor.grayColor()
        lblPulse.textColor = UIColor.grayColor()
        lblAED.textColor = UIColor.redColor()
    }
}




////
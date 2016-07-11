//
//  PlusMinusView.swift
//  HS Monitor
//
//  Created by Jongwoo Moon on 2016. 7. 4..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation

/** 
 
 뷰에서 기본 값 initVal : 0.56 이라면..
 stepF = 0.01
 valF = 0.12 이걸 100배 하여 Result에 표시

 valMax = 0.44 상위 리미트
 valMin = -0.56 하위 리미트
 

 

 
 */


class PlusMinusView : UIView {
    var log = HtLog(cName: "PlusMinusView")
    var openSendDataViewCljr: () -> () = { }

    var valueChanged : (Float) -> () = { val in }

    var val = 0, step = 1, stepF = 0.1, valF = 0.1, initVal = 0.5, valMax = 0.1, valMin = -0.1



    @IBOutlet weak var labelValue: UILabel!

    @IBOutlet weak var bttnPlu: UIButton!
    @IBOutlet weak var bttnMin: UIButton!

    @IBAction func bttnActPlus(sender: UIButton) {
        val += step;   valF += stepF
        print(" ++ val, valF : \(val)  \(valF)   max \(valMax)  initVal : \(initVal) ")
        // 여기서 리미트 체크.
        if valMax < valF { valF = valMax; val -= step }
        setValueLabel()
        valueChanged(Float(valF + initVal))
    }

    @IBAction func bttnActMinus(sender: UIButton) {
        val -= step;   valF -= stepF
        print("  val, valF : \(val)  \(valF)")
        // 여기서 리미트 체크.
        if valF < valMin { valF = valMin; val += step }
        setValueLabel()
        valueChanged(Float(valF + initVal))
    }

    func setValueLabel() {
        labelValue.text = String(Int(val))

        if val < 0 { labelValue.textColor = UIColor.redColor() }
        else { labelValue.textColor = UIColor.blackColor() }
    }

    func setConstraint() {

        let viewsDictionary = [ "minus": bttnMin, "value": labelValue, "plus": bttnPlu ]
        let metricsDictionary = [ "bttnWid": 30, "labelWid": 60, "margin": 50.0, "height": 70, "space": 100.0 ]
        // 폭 : 30 100 60 100 30 >> 320
        let horConstraintString = "H:|[minus(bttnWid)]-space-[value(labelWid)]-space-[plus(bttnWid)]"

        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(horConstraintString,
            options: NSLayoutFormatOptions.AlignAllCenterY,
            metrics: metricsDictionary, views: viewsDictionary))

        let vwArr = [ labelValue, bttnPlu, bttnMin ]

        for vw in vwArr {
            addConstraint(NSLayoutConstraint.init(item: vw, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal,
                toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0))
        }

        self.addConstraint(bttnMin.getConstAspectRatio(1))
        self.addConstraint(bttnPlu.getConstAspectRatio(1))
    }

    func initSet(stp: Int, iniVal: Float) {
        setConstraint()
        setLanguageString()
        setValueLabel()

        val = 0; valF = 0;
        initVal = Double(iniVal)
        step = stp; stepF = Double(step) * 0.01

        // limit set
        valMax = 1 - initVal;  valMin = -initVal

        print(" initSet :: \(initVal)   \t   valMax/Min \(valMax) \(valMin)  ")

        bttnPlu.setImage(UIImage(named: "bttnPluRed"), forState: .Highlighted)
        bttnMin.setImage(UIImage(named: "bttnMinRed"), forState: .Highlighted)

        bttnPlu.tag = 1
        bttnMin.tag = 0
    }

    func setLanguageString() {
    }

}

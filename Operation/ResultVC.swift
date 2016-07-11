//
//  ResultVC.swift
//  heartisense
//
//  Created by Jongwoo Moon on 2015. 10. 22..
//  Copyright © 2015년 gyuchan. All rights reserved.
//


import UIKit
import PSAlertView

@IBDesignable

class ResultVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var log = HtLog(cName: "ResultVC")
    var theTimer = NSTimer()
    var dObj = HsBleManager.inst().dataObj
    var currentStep : CurStep { get { return HsBleManager.inst().bleState } }
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var resultTableVw: UITableView!
    @IBOutlet weak var lblNumOfSuccess: UILabel!
    
    @IBOutlet weak var labelSet: UILabel!
    @IBOutlet weak var labelCompression: UILabel!
    @IBOutlet weak var labelBreath: UILabel!

    @IBOutlet weak var bttnRepeat: UIButton!
    @IBOutlet weak var bttnComplete: UIButton!
    
    var gotoMainClj:(Void)->Void = { }
    var repeatClj:(Void)->Void = { }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ResultCell", bundle: nil)
        resultTableVw.registerNib(nib, forCellReuseIdentifier: "rsltCell")

        localizeString()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        log.printThisFNC("viewWillAppear", comment: "  localize .... ")
        
        if !isBypassMode { return }

        bttnRepeat.hidden = true
        bttnComplete.hidden = true
        
        HsBleManager.inst().operationStop()
        
        theTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, // second
            target:self, selector: #selector(ResultVC.uiUpdateAction),
            userInfo: nil, repeats: true)

    }

    func localizeString() {
        labelTitle.text = langStr.obj.result
        lblNumOfSuccess.text = langStr.obj.result_guide
        labelSet.text = langStr.obj.cycle
        labelCompression.text = langStr.obj.compression // lo calStr("compression_simple")
        labelBreath.text = langStr.obj.breath // lo calStr("respiration_simple")
        bttnRepeat.setTitle(langStr.obj.repeatKey, forState: .Normal)
        bttnComplete.setTitle(langStr.obj.complete, forState: .Normal)
    }
    
    func uiUpdateAction() {
        switch currentStep {
        case .S_WHOLESTEP_RESULT, .S_WHOLESTEP_AED:
            print("  Bypass Mode Result ...      wait .....")
        default:
            print(" ResultVC ::  quit or something ...  changed ....  dismissVC  .....")
            detachFromSuperView() // dismissThisView()
        }
        if !HsBleManager.inst().isConnected {
            print("\n\n\n\n\n  ResultVC >>   DisConnected   ||  isBypassMode   \n\n\n\n\n")
            detachFromSuperView() // dismissThisView()
        }
    }

    func detachFromSuperView() {
        theTimer.invalidate()
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

    func dismissThisView() {
        theTimer.invalidate()
        self.dismissViewControllerAnimated(viewAnimate, completion: nil)
    }
    
    @IBOutlet weak var bttnActRepeat: UIButton!
    
    
    @IBAction func bttnActRepeat(sender: UIButton) {
        repeatClj()
        detachFromSuperView() // dismissThisView()
    }
    
    @IBAction func bttnActComplete(sender: UIButton) {
        goToMainView()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Int(HsBleSingle.inst().stageLimit)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("  CustomTVC : \(indexPath.row) ")
        let cell:ResultCell = tableView.dequeueReusableCellWithIdentifier("rsltCell") as! ResultCell
        let i = indexPath.row
        cell.setItems(i)
        return cell
    }

    func goToMainView() {
        let alert = PSPDFAlertView(title: langStr.obj.to_main, message: langStr.obj.want_main)
        alert.alertViewStyle = UIAlertViewStyle.Default
        alert.setCancelButtonWithTitle(langStr.obj.yes, block: {
            (buttonIndex : NSInteger) in


            self.detachFromSuperView()
            self.gotoMainClj()

            //self.theTimer.invalidate()
            //self.dismissViewControllerAnimated(viewAnimate, completion: {  self.gotoMainClj() })
            //self.navigationController?.popToViewController(self.navigationController?.viewControllers[1], animated: true)
        })
        alert.show()
    }
}

class ResultCell : UITableViewCell {
    @IBOutlet weak var lblSetNum: UILabel!
    @IBOutlet weak var lblComp: UILabel!
    @IBOutlet weak var lblResp: UILabel!
    var dObj = HsBleManager.inst().dataObj
    
    func setItems(setNumFrom0: Int) {
        switch langIdx {
        case 1:
            lblSetNum.text = "\(setNumFrom0 + 1) 주기"
        default:
            lblSetNum.text = "Cycle \(setNumFrom0 + 1)"
        }

        let stgObj = dObj.arrSet[setNumFrom0]
        lblComp.text = " \(stgObj.ccPassCnt) / \(stgObj.ccCount) "
        lblResp.text = " \(stgObj.rpPassCnt) / \(stgObj.rpCount) "
    }
}




//
//  SelectModeVC.swift
//  heartisense
//
//  Created by Jongwoo Moon on 2015. 10. 21..
//  Copyright © 2015년 gyuchan. All rights reserved.
//


import UIKit
import PSAlertView

@IBDesignable


class JustVC: UIViewController {
    
}


class SelectModeVC: UIViewController, UIActionSheetDelegate {
    var log = HtLog(cName: "SelectModeVC")
    var isDoctor:Bool? = nil  //  isRescureMode  에 반영됨.
    var uiTimer = NSTimer()
    var curStepWatch = MuState()
    
    var gotoBypassReadyView = HtUnitLogic()
    var gotoBypassOperationVw = HtUnitLogic()
    
    var bypass: HsBypassManager?

    @IBOutlet weak var bttnNormal: UIButton!
    @IBOutlet weak var bttnDoctor: UIButton!
    @IBOutlet weak var bttnStep: UIButton!
    @IBOutlet weak var bttnWinO: UIButton!
    
    @IBOutlet weak var lblRescureMode: UILabel!
    @IBOutlet weak var lblDoctorMode: UILabel!
    @IBOutlet weak var lblStepByStep: UILabel!
    @IBOutlet weak var lblWholeInOne: UILabel!
    
    @IBOutlet weak var imgVertLine: UIImageView!
    @IBOutlet weak var consLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var consTrailingSpace: NSLayoutConstraint!

    @IBAction func bttnActInfo(sender: UIButton) {
        openHeartisenseInfoWeb(0) // 0: Trainer
    }
    
    @IBAction func bttnActSetting() {

        let setAct = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil,
            otherButtonTitles:langStr.obj.option_preference, // loc alStr("setting_init"),
            langStr.obj.option_calibration) //            loc alStr("setting_sensitivity"))
        
        setAct.showInView(self.view)
        
//        UIActionSheet *setAct = [[UIActionSheet alloc]
//            initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
//            otherButtonTitles:[NSString autolocalizingStringWithLocalizationKey:@"setting_init"],
//            [NSString autolocalizingStringWithLocalizationKey:@"setting_sensitivity"], nil];
//        [setAct showInView:self.view];
    }
    
    @IBAction func leftBttnTouched(sender: UIButton) {
        bttnNormal.selected = false
        bttnDoctor.selected = false
        sender.selected = true
        isDoctor = bttnDoctor.selected
        if isDoctor! == true { isRescureMode = false } else { isRescureMode = true }
        rightButtonShow(true)
    }
    
    override func viewDidLoad() {
        log.printThisFunc(" viewDidLoad ", lnum: 3)
    }

    var appInfoCheckJob = UnitJob(name: "바이패스 ..  앱 인포 요청")
    
    func connectionSuccessAction() {       // 디바이스가 모니터와 연결..
        
        if (HsBleManager.inst().bleState == .S_QUIT) { return }
        
        if (bypass?.isMonitor.value == true && bypass?.isMonitor.intVal == 0) {
            appInfoCheckJob.initJob = {
                HsBleManager.inst().cellService?.instructorAppInfoRequest()
            }
            appInfoCheckJob.didFinished = { (Void)->Bool in
                
                self.log.printThisFunc("   check >>   \(self.bypass?.isMonitor.intVal)  > 0 ???   \(self.bypass?.isMonitor.intVal > 0)   앱 인포..  ", lnum: 5)
                
                return self.bypass?.isMonitor.intVal > 0 }
            appInfoCheckJob.retryLimit = 10
            appInfoCheckJob.startProcess()
        }
    }

    func rightButtonShow(show: Bool) {
        bttnStep.show_다음이_참이면(show)
        bttnWinO.show_다음이_참이면(show)
        lblStepByStep.show_다음이_참이면(show)
        lblWholeInOne.show_다음이_참이면(show)
    }

    func showLeftBttns(show: Bool) {
        bttnNormal.show_다음이_참이면(show)
        bttnDoctor.show_다음이_참이면(show)
        lblDoctorMode.show_다음이_참이면(show)
        lblRescureMode.show_다음이_참이면(show)
        imgVertLine.show_다음이_참이면(show)

        if show {
            rightButtonShow(false) // 버튼 가리기..
            bttnNormal.selected = false
            bttnDoctor.selected = false
            consLeadingSpace.constant = 534
            consTrailingSpace.constant = 85
        } else {
            rightButtonShow(true)
            consLeadingSpace.constant = 250
            consTrailingSpace.constant = 250
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        log.printThisFunc("viewWillAppear", lnum: 3)

        uiUpdateAction()

        uiTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, // second
            target:self, selector: #selector(SelectModeVC.uiUpdateAction),
            userInfo: nil, repeats: true)

        bypass = HsBleManager.inst().bypass
        //log.printAlways(" bypass ::  \(bypass)")

        // CPR Guideline 에 따른 추가 조작...
        if cprProtoN.theVal == 0 {
//            rightButtonShow(false) // 버튼 가리기..
//            bttnNormal.selected = false
//            bttnDoctor.selected = false
        }

        showLeftBttns(cprProtoN.theVal == 0)

        // 이게 앱 구동 후 처음 올 때와..  Ready에서 이동할 때를 구분해야 함..
        if isBypassMode { connectionSuccessAction() }
        
        // 준비 화면으로 가는 로직
        gotoBypassReadyView.theMainCondition = { return HsBleManager.inst().bleState == .S_READY }
        gotoBypassReadyView.theMainVoidJob = {
            self.log.printThisFunc(" BypassReady 로 간다.  isBypassMode : \(isBypassMode) ", lnum: 10)

            if !isBypassMode { return }

            self.uiTimer.invalidate()
            let dvc = BypassReadyVC (nibName: "BypassReadyVC", bundle: nil);
            self.navigationController?.pushViewController(dvc, animated: viewAnimate)
        }
        
        gotoBypassOperationVw.theMainCondition = { return (self.bypass?.gotoOperationView())! }
        gotoBypassOperationVw.theMainVoidJob = {
            
            self.log.printThisFunc(" OperationViewCtrl 로 간다. ", lnum: 10)
            
            self.uiTimer.invalidate()
            let vc = OperationViewCtrl(nibName: "StepByStepTrialViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: viewAnimate)
        }

        setLanguageString()
    }


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        print("  SelectModeVC   ::   navigationController?.viewControllers.count  >>  \(navigationController?.viewControllers.count)")

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        log.printThisFunc("viewWillDisappear", lnum: 5)
        
        uiTimer.invalidate()
        //HsBleManager.inst().backToReady() 이게..  바이패스에서 Operation 뷰로 넘어갈 때 오작동 원인이 됨...
    }
    
    var alert = PSPDFAlertView(title: nil, message: "")

    // func showAlertPopupOfGoHomexx() {  extension 으로 뺐슴.

    func uiUpdateAction() {
        if !HsBleManager.inst().isConnected {
            print("\n\n\n\n\n   SelectModeVC   DisConnected   \n\n\n\n\n")
            showAlertPopupOfGoHome()  //navigationController?.popToRootViewControllerAnimated(true)
            uiTimer.invalidate()
        }
        
        if HsBleManager.inst().bleState == .S_QUIT && isBypassMode == true { // 바이패스 끝나면 ..  처음으로..
            log.printAlways("  currentStep == .S_QUIT && isBypassMode == true  ")
            isBypassMode = false
            HsBleManager.inst().bleState = .S_INIT0
        }
        
        if (!isBypassMode && bypass?.isMonitor.intVal == 0) { return; } // 바이패스 모드만 아래 실행..
        
        log.logThis("  App Info ??   \(bypass?.isMonitor.intVal)   ", lnum: 0)
        
        if bypass?.quitApplication() == true {
            log.printThisFunc("  bypass?.quitApplication() == true  ", lnum: 5)
            
            var messge = ""
            if bypass?.isMonitor.intVal == 2 { messge = langStr.obj.bls_using }     // Test
            else {  messge = langStr.obj.calibration_using }                        // Calibration
            
            print("  \n\n\n\n\n  여기서 이유를 말하고 앱 종료.. \(messge) \n\n\n\n\n ")
            uiTimer.invalidate()
            alert = PSPDFAlertView(title: nil, message: messge)
            alert.alertViewStyle = UIAlertViewStyle.Default
            alert.show()
            
            HsGlobal.delay(3.0, closure: { () -> () in
                exit(0)
            })
            return
        }
        
        gotoBypassReadyView.updateAction()
        gotoBypassOperationVw.updateAction()
        
        log.함수차원_출력_End()
    }
    
    func openOperationView() { // 바이패스가 아닐 때..
        log.printAlways("  openOperationView  ")
        let vc = OperationViewCtrl(nibName: "StepByStepTrialViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: viewAnimate)
    }
    
    @IBAction func bttnActStepByStep(sender: UIButton) {
        log.printThisFunc("단계별 학습 버튼 선택", lnum: 10)
        HsBleManager.inst().parsingState = StepByStep20
        if 0 == cprProtoN.theVal {
            HsBleManager.inst().bleState = .S_STEPBYSTEP_RESPONSE
        } else {
            HsBleManager.inst().bleState = .S_STEPBYSTEP_SAFETY
        }
        openOperationView()
    }
 
    @IBAction func bttnActWholeInOne(sender: UIButton) {
        log.printThisFunc("전과정 학습 버튼 선택", lnum: 10)
        HsBleManager.inst().parsingState = AllInOne10
        HsBleManager.inst().bleState = .S_WHOLESTEP_DESCRIPTION;
        openOperationView()
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 0) {
            let  vc = InitialSettingVCTrn(nibName: "InitialSettingVC", bundle: nil)
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(vc, animated: viewAnimate, completion: nil)
            } )
        }
        if buttonIndex == 1 {
            if (!HsBleManager.inst().isConnected) {
                //UIAlertView *alertView;
                let alertView = UIAlertView(title: langStr.obj.need_connect_kit, message: nil, delegate: self,
                                            cancelButtonTitle: langStr.obj.confirm)
                alertView.show()
            } else {
                
                //let senseVC = SensivitySettingVC()
                let senseVC = CalibrationVC()
                senseVC.setBleObject(HsBleManager.inst())
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(senseVC, animated: viewAnimate, completion: nil)
                    //self.navigationController?.pushViewController(senseVC, animated: viewAnimate)
                }
            }
        }
    }

    // MARK:  언어 세팅.
    func setLanguageString() {
        lblRescureMode.text = langStr.obj.lay_rescuer // l ocalStr("non_professional")
        lblDoctorMode.text = langStr.obj.bls_rescuer // l ocalStr("ems_professional")
        lblStepByStep.text = langStr.obj.step_by_step_mode_full // lo calStr("tutorial_mode")
        lblWholeInOne.text = langStr.obj.whole_step_mode_full // l ocalStr("practical_skills_mode")

    }
    
}
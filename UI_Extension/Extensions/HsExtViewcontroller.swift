//
//  HsExtViewcontroller.swift
//  Trainer
//
//  Created by Jongwoo Moon on 2016. 1. 8..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation
import LG

extension UIViewController {

    func openHeartisenseInfoWeb(appKind: Int) { // 0: Trainer, 1: Monitor, 2: Test
        var appStr = "", langStr = ""         //extern int langIdx, state; // 0 : Eng, 1 : Kor
        switch langIdx {
        case 1: langStr = "K"
        default: langStr = "E"
        }
        switch appKind {
        case 0:
            appStr = "http://www.heartisense.com/pdf/HeartiSense%20Trainer_AppGuide_"
        case 1:
            appStr = "http://www.heartisense.com/pdf/HeartiSense%20Monitor_AppGuide_"
        default:
            appStr = "http://www.heartisense.com/pdf/HeartiSense%20Test_AppGuide_"
        }
        UIApplication.sharedApplication().openURL(NSURL(string: "\(appStr)\(langStr).pdf")!)
    }

    //  http://www.heartisense.com/eng/support/faq.php

    func openExcelImportGuide() {
        UIApplication.sharedApplication().openURL(NSURL(string:"http://www.heartisense.com/eng/support/faq.php")!)
    }

    func showGeneralPopup(title: String?, message: String, yesStr: String, noString: String,
        yesAction: Void -> Void, noAction: Void -> Void = { }) {
            let actionSheetController: UIAlertController = UIAlertController(title: title,
                message: message, preferredStyle: .Alert)
            //Create and an option action
            actionSheetController.addAction(UIAlertAction(title: yesStr, style: .Default)
                { action -> Void in
                    yesAction()
                })
            actionSheetController.addAction(UIAlertAction(title: noString, style: .Default)
                { action -> Void in
                    noAction()
                })
            presentViewController(actionSheetController, animated: viewAnimate, completion: nil)
    }

    func showWantBackMessage(okCallBack : Void -> Void  ) {
        let actionSheetController: UIAlertController = UIAlertController(title: langStr.obj.cancel,
            message: langStr.obj.want_back, preferredStyle: .Alert)
        //Create and an option action
        actionSheetController.addAction(UIAlertAction(title: langStr.obj.yes, style: .Default)
            { action -> Void in
                okCallBack()
            })
        actionSheetController.addAction(UIAlertAction(title: langStr.obj.no, style: .Default)
            { action -> Void in
                //Do some stuff 추가적으로 할일 없슴..
            })
        presentViewController(actionSheetController, animated: viewAnimate, completion: nil)
    }


    func showConnectionSuccessMessage(kitID: String) {
        let actionSheetController: UIAlertController = UIAlertController(title: nil,
            message: langStr.obj.connect_success + " ( " + kitID + " )", preferredStyle: .Alert)
        //Create and an option action
        //Present the AlertController
        presentViewController(actionSheetController, animated: viewAnimate, completion: nil)
        HsGlobal.delay(2.0) { () -> () in
            actionSheetController.dismissViewControllerAnimated(viewAnimate, completion: { () -> Void in
                print(" 연결 성공 뷰 :: dismiss \(langStr.obj.connect_success)")
            })
        }
    }

    func showSimpleMessageWith(message: String, yesCallBack: Void -> Void = { }) { // , style: UIAlertActionStyle) {
        let actionSheetController: UIAlertController = UIAlertController(title: nil,
            message: message, preferredStyle: .Alert)
        //Create and an option action
        actionSheetController.addAction(UIAlertAction(title: langStr.obj.confirm, style: .Default)
            { action -> Void in
                yesCallBack()
                //Do some other stuff
            })
        presentViewController(actionSheetController, animated: viewAnimate, completion: nil)
    }

    func showAlertctrlRestart() { // 재시작 팝업...
        let actionSheetController: UIAlertController = UIAlertController(title: langStr.obj.restart,
            message: langStr.obj.want_restart_training, preferredStyle: .Alert)
        //Create and an option action
        actionSheetController.addAction(UIAlertAction(title: langStr.obj.yes, style: .Default)
            { action -> Void in
                //Do some other stuff
            })
        //Create and add the Cancel action
        actionSheetController.addAction(UIAlertAction(title: langStr.obj.no, style: .Default)
            { action -> Void in
                //Do some stuff 추가적으로 할일 없슴..
            })
        //Present the AlertController
        presentViewController(actionSheetController, animated: viewAnimate, completion: nil)
    }


    func showAlertPopupOfGoHome() {
        let alertVw = PSPDFAlertView(title: langStr.obj.error, message: langStr.obj.disconnect_kit)
        alertVw.setCancelButtonWithTitle(langStr.obj.confirm) { (idx) -> Void in
            self.navigationController?.popToRootViewControllerAnimated(viewAnimate)
        }
        alertVw.show()
    }


    func showGoToMainView(okBlock: ()->()) {
        let alertVw = PSPDFAlertView(title:langStr.obj.to_main, message:langStr.obj.want_main)
        alertVw.setCancelButtonWithTitle(langStr.obj.yes) { (idx) -> Void in
            okBlock()
        }
        alertVw.addButtonWithTitle(langStr.obj.no, block: nil)
        alertVw.show()
    }


    func showAlertPopupOfBackToMainInfant(okBlock: ()->()) {
        let alertVw = PSPDFAlertView(title: langStr.obj.to_main, message: (langStr.obj.want_main))
        alertVw.setCancelButtonWithTitle(langStr.obj.yes) { (idx) -> Void in
            self.navigationController?.popToRootViewControllerAnimated(viewAnimate)
            okBlock()
        }
        alertVw.addButtonWithTitle(langStr.obj.no, block: nil)
        alertVw.show()
    }

    func showAlertPopupOfBackToMainInMonitor(okBlock: ()->()) {
        let alertVw = PSPDFAlertView(title: langStr.obj.to_main, message: (langStr.obj.want_main + "  " + langStr.obj.bt_off_msg))
        alertVw.setCancelButtonWithTitle(langStr.obj.yes) { (idx) -> Void in
            self.navigationController?.popToRootViewControllerAnimated(viewAnimate)
            okBlock()
        }

        alertVw.addButtonWithTitle(langStr.obj.no, block: nil)
        alertVw.show()
    }


}

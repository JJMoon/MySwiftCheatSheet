//
//  OperationViewCtrl.m
//  heartisense
//
//  Created by Jongwoo Moon on 2015. 10. 14..
//  Copyright © 2015년 gyuchan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

#import "StepByStepTrialViewController.h"
#import "OperationViewCtrl.h"
#import "NSObject+util.h"
#import "Common-Swift.h"

//#import "SelectModeViewController.h"
#import "HSAttributedString.h"

#import "HSCentralManager.h"
#import "PSPDFAlertView.h"
#import "DPLocalizationManager.h"

#import "HSDataCalculator.h"
#import "HSStepDataCalculator.h"
#import "HSDataStaticValues.h"
#import "HsBleManager.h"




@interface OperationViewCtrl() {
    
    HtLog* log;

    bool parseChanged; // step <--> all in one 전환.
    ParsingState prevParseState;

    bool wasSingleMode;
    
}

@end




//////////////////////////////////////////////////////////////////////     _//////////_     [ StepByStepTrialViewController ]    _//////////_  바이패스 모드를 위한 클래스임..
@implementation OperationViewCtrl
//////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
    log = [[HtLog alloc] initWithCName:@"OperationViewCtrl" active: true];
    
    wasSingleMode = !isBypassMode; // 처음 상태..
    
    [self logCallerMethodwith:[NSString stringWithFormat:@"  parsingState : %d", HsBleManager.inst.parsingState] newLine:3];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    
    [self logCallerMethodwith:@"모드에 따른 분기" newLine:10];
    
    if ([self viewEscapeCheck]) {
        return;
    }
    
    // 모드에 따른 분기
    //if (isBypassMode)        [self setHeaderButtons];    else {
        if (HsBleManager.inst.parsingState == AllInOne10)         [self AllInOneInitProcess];
        if (HsBleManager.inst.parsingState == StepByStep20)       [self setHeaderButtons];
    //}
    prevParseState = HsBleManager.inst.parsingState;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self logCallerMethodwith:@" 냉무 " newLine:3];
}

- (BOOL)viewEscapeCheck {
    CurStep currentStep = HsBleManager.inst.bleState;
    if (currentStep == S_QUIT || currentStep == S_INIT0) {
        [self logCallerMethodwith:@"  pop and DON'T change  currentStep  to   >>> S_INIT0  Stay   .....   ;  " newLine:5];
        //currentStep = S_INIT0;
        [self.navigationController popViewControllerAnimated:viewAnimate];
        NSLog(@"  이게 프린트 될까? ");
        return true;
    }
    
    if (currentStep == S_READY) {
        NSLog(@"  It's   bypass  &&   ready ...   dismiss ... ");
        [self.navigationController popViewControllerAnimated:viewAnimate];
        return true;
    }
    return false;
}


//////////////////////////////////////////////////////////////////////     _//////////_     [ UI || UX         << >> ]    _//////////_
#pragma mark - UI / UX
- (void)uiUpdateAction {
    [super uiUpdateAction];
    CurStep currentStep = HsBleManager.inst.bleState;

    if (isBypassMode && wasSingleMode) {
        NSLog(@"OperationViewCtrl :: popViewControllerAnimated  >>> @ 112  ");
        [self.navigationController popViewControllerAnimated:viewAnimate];
        return;
    }
    
    if (!isBypassMode)   return;
    
    if (HsBleManager.inst.parsingState == StepByStep20) {
        //[log printAlways:@"  uiUpdateAction ..  신호등 끄기 ...." lnum:5];
        [self turnOffSignals];
    }
    
    //NSLog(@" OperationView ::  isBypassMode ....        UI Update Action     %@", [HsUtil curStepStr]);
    //NSLog(@" is ready? %d  curWatch.ischanged %d", currentStep == S_READY, curStepWatch.isChanged);
//    
//    if (prevParseState != HsBleManager.inst.parsingState) { //  step <--> all in one 전환.
//        [self logCallerMethodwith:@"  step < -- > all in one  전환 " newLine:20];
//        
//        [self.navigationController popViewControllerAnimated:true];
//        return;
//
//        prevParseState = HsBleManager.inst.parsingState;
//        if (prevParseState == AllInOne10) {
//            [self AllInOneInitProcess];
//        } else {
//            [self setResponse];
//        }
//    }

    [self viewEscapeCheck];
    
//    if (currentStep == S_QUIT) {
//        [self.navigationController popToViewController:
//         [[self.navigationController viewControllers] objectAtIndex:1] animated: viewAnimate];
//    }
    
    
    if (curStepWatch.isChanged || currentStep == BypassStepComp || currentStep == BypassStepBrth) { // 바이패스 패킷에 의해 상태가 변하면 그에 따른 처리..
        NSLog(@"\n\n   OperationView.m   바이패스 패킷에 의해 상태가 변하면 그에 따른 처리  ...  %@ \n\n",
              [HsUtil curStepStr:currentStep]);
        
        switch (currentStep) {
            case S_STEPBYSTEP_SAFETY:           [self setSafety];           break;
            case S_STEPBYSTEP_AIRWAY:           [self setAirWay];           break;
            case S_STEPBYSTEP_CHECK_BRTH:       [self setCheckBreath];      break;

            case S_STEPBYSTEP_RESPONSE:         [self setResponse];         break;
            case S_STEPBYSTEP_EMERGENCY:        [self setEmergency];        break;
            case S_STEPBYSTEP_CHECKPULSE:       [self setCheckPulse];       break;

            case BypassStepComp:     //case S_STEPBYSTEP_COMPRESSION:
                HsBleManager.inst.bleState = S_STEPBYSTEP_COMPRESSION;

                // xxx 여기서 시그널뷰를꺼  주자.
                if (signalVw != nil) {
                    NSLog(@"  // xxx 여기서 시그널뷰를꺼  주자. ");
                    //[signalVw removeFromSuperview];
                    signalVw.hidden = true;
                    //signalVw = nil;
                }

                [self startCompression];    break;
            case BypassStepBrth: // S_STEPBYSTEP_BREATH:
                HsBleManager.inst.bleState = S_STEPBYSTEP_BREATH;
                if (signalVw != nil) signalVw.hidden = true;
                [self startBreathProcess];  break;
            case S_STEPBYSTEP_AED:              [self setAED];              break;
                
            case WholeStepStart: // S_WHOLESTEP_DESCRIPTION: // 처음 들어올 때..  이게 아닐지..
                HsBleManager.inst.bleState = S_WHOLESTEP_DESCRIPTION;
                [self logCallerMethodwith:@" 현재 S_WHOLESTEP_DESCRIPTION  ..  임..  " newLine:5];
                [self AllInOneInitProcess];
                break;
            //case S_WHOLESTEP_COMPRESSION: // 강사가 의도적으로 스킵할 때..
            case S_WHOLESTEP_PRECPR: // 강사가 의도적으로 스킵할 때..
                [self logCallerMethodwith:@" 현재 S_WHOLESTEP_COMPRESSION   스킵했을 때.  ..  임..  " newLine:5];
                if (HsBleManager.inst.stage == 1) {  // 스테이지가 바뀔때는 이거 하지 말아야 함..
                    [self startWholeInOneProcessWithCompression];
                }
                break;
            case S_WHOLESTEP_RESULT:
                [skipLastAED doSetValue:true];
                break;
                
            default:       break;
        }
    }
    
//    if (prevStep != currentStep) { // 압박 <--> 호흡 전환.
//    }
    
    
}


@end
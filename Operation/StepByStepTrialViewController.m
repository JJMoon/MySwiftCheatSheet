//
//  StepByStepTrialViewController.m
//  heartisense
//
//  Created by jeongyuchan on 2015. 5. 1..
//  Copyright (c) 2015년 gyuchan. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "StepByStepTrialViewController.h"
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
// #import "HsProcessManager.h"  요건 나중에..
#import "HsBleManager.h"
#import "HsBleSingle.h"

@interface StepByStepTrialViewController() {
    HtLog* log;  HsBleManager* bleMan;
    
    double timerGap;  NSTimer* uiTimer;
    void (^stepRetryMethod)(void);
    HsGlobal *hsGlb4Colr;
    Byte aedIdx;
    HtAudioPlayer *audioPlayer, *audioCount;
    UnitJob* allInOneJobs;
    bool isKorean, showResultView;
    CABasicAnimation *blinkAni;
    UIView *headerButtonsView;
    
    HovHoldingTimeView* holdingTimeView;
    //HovSignalView* signalView;
    HtDelayTimer *resultViewTimer;
    BOOL showAEDAction, isPreCompress;
    PSPDFAlertView *sensorLostAlertView;
    HtPauseCtrlTimer *narationCtrl;    // pause 관련..
    
    HtGeneralStateManager *arrCompBrthStt;
    UIFont *fontTitle, *fontContent;
    
    HsData *dObj;
    NSMutableArray* arrButtons;

    HsSpeedLogic *spdLgc; // 스피드 처리 로직...

    StrLocBase *lObj;

    //TrainerSignalView *signalVw;
}

@end


//////////////////////////////////////////////////////////////////////     _//////////_     [ StepByStepTrialViewController ]    _//////////_
@implementation StepByStepTrialViewController
//////////////////////////////////////////////////////////////////////////////////////////

@synthesize skipLastAED, signalVw;

- (void)viewDidLoad {
    [super viewDidLoad];

    // 노랑 폭 : 0.58 / Green : 0.2 / Red : 0.22  // 58 / 78 / 100
    // Prestan :: 54 / 72  0.54 / 0.18 / 0.28
    float yl = 0.58, gr = 0.2, rd = 0.22;
    //if (HsBleSingle.inst.manikinKind.theVal == 1) {        yl = 0.54; gr = 0.18; rd = 0.28;    } // 그냥 depth 를 키운다..

    NSLayoutConstraint *yellowWidth = [NSLayoutConstraint constraintWithItem:_labelCompYelow
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_viewGraphMarkComp
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:yl constant:0];
    NSLayoutConstraint *greenWidth = [NSLayoutConstraint constraintWithItem:_labelCompGren
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_viewGraphMarkComp
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:gr constant:0];
    NSLayoutConstraint *redWidth = [NSLayoutConstraint constraintWithItem:_labelCompRed
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_viewGraphMarkComp
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:rd constant:0];
    [_viewGraphMarkComp addConstraint:yellowWidth];
    [_viewGraphMarkComp addConstraint:greenWidth];
    [_viewGraphMarkComp addConstraint:redWidth];

    log = [[HtLog alloc] initWithCName:@"StepByStepViewController" active: true];
    bleMan = HsBleManager.inst;
    lObj = HsBleSingle.inst.langObj;

    _scrlVwExplain.contentSize = _descriptionLabel.bounds.size;
    [self.view bringSubviewToFront:_scrlVwExplain];
    timerGap = 0.03;
    dObj = [HsBleManager inst].dataObj;
    
    [self setManikinImage];
    [self infoImageHideInBypass];
    [HsUtil prinCurStep:@"  Step by Step   >>>  viewDidLoad  VC"];
    
    // 압박 멈춤 시간 뷰 세팅..  추가
    holdingTimeView = [[[NSBundle mainBundle] loadNibNamed:@"HoldingTime" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:holdingTimeView];
    _labelTryNum.text = lObj.count;
    _labelTime.text = lObj.timer;
    _labelCount.text = lObj.count;
    fontTitle = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:25.0];
    fontContent = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:19.0];
    _lblSignalMsg.hidden = true;

    // 스탑 와치 ..   뷰 ..
    //151202 uiStopWatch = [[HtStopWatch alloc] init];
    curStepWatch = [[MuState alloc] initWithName:@"WatchIn Step VC"];  // 상태 감시
    hsGlb4Colr = [[HsGlobal alloc ] init];
    
    [bleMan stopScan];    [bleMan operationStop];  // 일단은 모든 기능 정지..
    
    switch (langIdx) {
        case 0:             isKorean = false;   break;
        case 1:  default:   isKorean = true;    break;
    }
    
    //Setting ProgressView  카운트...
    [_countProgressView setProgressDirection:M13ProgressViewBarProgressDirectionLeftToRight];
    [_countProgressView setPercentagePosition:M13ProgressViewBarPercentagePositionTop];
    [_countProgressView setPrimaryColor:[UIColor whiteColor]];
    
    // 세기 표시 프로그레스 뷰 .....
    //[_progressView setNumberOfSegments:60];
    //[_progressView setProgressDirection:M13ProgressViewSegmentedBarProgressDirectionLeftToRight];
    [_progressCount setProgressDirection:M13ProgressViewSegmentedBarProgressDirectionLeftToRight];
    _progressCount.primaryColors = hsGlb4Colr.countFG;
    _progressCount.secondaryColors = hsGlb4Colr.countBG;
   }

- (void)viewWillAppear:(BOOL)animated {
    [self logCallerMethodwith:@"  timer set  " newLine:5];
    [holdingTimeView setLanguageString];
    [self infoImageHideInBypass];
    __weak StepByStepTrialViewController* this = self;
    bleMan.bypassModeChanged = ^{ [this bypassModeChangedAction]; };

    if (isBypassMode) {  // 세 버튼을 숨기냐 마냐...
        _bttnGoHome.hidden = _bttnPause.hidden = _bttnRetrySkip.hidden = true;
    }

    skipLastAED = [[HtNullableBool alloc] init];
    uiTimer = [NSTimer scheduledTimerWithTimeInterval:timerGap target:self
                                             selector:@selector(uiUpdateAction) userInfo:nil repeats:YES];
    bleMan.isPausing = isPreCompress = false;
    [self uiInitialize];
    
    [_progressCount setNumberOfSegments:120];

    [self setSpeedLogic];
}

- (void)setSpeedLogic {
    /// 스피드 로직 관련....
    spdLgc = [[HsSpeedLogic alloc] init];
    [spdLgc setLabels:_labelSpeed slow:_labelSpdSlow good:_labelSpdGood fast:_labelSpdFast];
    [spdLgc setImages:_imgSpdSlow god:_imgSpdGood fst:_imgSpdFast sign:_imgSlowFastSign sign2:_imgVwMsgDn];
    [spdLgc addSingleView:_labelSpeedBackground];
    bleMan.calcManager.speedLogic = spdLgc; // 할당...
    [spdLgc hideOrShowAll:true];
    [spdLgc deactivateAll];
    [spdLgc setLanguageString];
}

- (void)viewDidAppear:(BOOL)animated {
    if (bleMan.bleState == S_STEPBYSTEP_RESPONSE) {
        [self setResponse];
    }
    if (bleMan.bleState == S_STEPBYSTEP_SAFETY) {
        [self setSafety];
    }
}

- (void)setSignalView {
    if (signalVw == nil) {
        signalVw = [[TrainerSignalView alloc] init];
        signalVw.frame = CGRectMake(100, 500, 900, 200);
        [self.view addSubview:signalVw];
    }
    [signalVw setERCprotocol:self.view];
    signalVw.hidden = false;

    // Label
    _lblSignalMsg.text = lObj.press_sensor_pad;
    _lblSignalMsg.hidden = false;


    signalVw.translatesAutoresizingMaskIntoConstraints = false;

    // 1024- 910 = 114 ..  57     130 * 5 + 5 * 4 = 650 + 20 >> 670  ...  1024 - 670 = 354 / 2
    CGFloat distX = 114 / 2;
    if (HsBleSingle.inst.cprProto.theVal == 0) {
        distX = 354 / 2;
        if (isRescureMode) distX += 67;
    }

    NSLayoutConstraint *cntrY = [NSLayoutConstraint constraintWithItem:signalVw attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *cntrX = [NSLayoutConstraint constraintWithItem:signalVw attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant: distX];
    NSLayoutConstraint *cntrW = [NSLayoutConstraint constraintWithItem:signalVw attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    [self.view addConstraint:cntrX]; [self.view addConstraint:cntrY]; [self.view addConstraint:cntrW];
}


- (void)viewWillDisappear:(BOOL)animated {
    bleMan.bypassModeChanged = ^{ NSLog(@" Leaved from Stepbystep VC ..   "); };
    
    [self logCallerMethodwith:@"  [uiTimer invalidate];  " newLine:10];
    [uiTimer invalidate];  // 타이머 죽이기..
    uiTimer = nil;
    [self audioStop];
}

- (IBAction)bttnActInfo:(UIButton *)sender { // 도움말 웹 페이지로 이동.
    [self openHeartisenseInfoWeb:0]; // Trainer
}

- (IBAction)bttnSendPacket { // 4 debugging
    //[bleMan saveToKitWithComp:88 andRspr:99];
    NSLog(@"\n\n\n  bttnSendPacket     \n\n\n");
    NSLog(@" is ready? %d", bleMan.bleState == S_READY);
}


- (IBAction)pause:(id)sender { // pause ...
    [log logUiAction:@"pause:(id)sender" lnum:2 printOn:true];
    [self pauseAction];
}

- (void)pauseAction {
    bleMan.isPausing = !bleMan.isPausing;
    NSLog(@"  현재 pause ..  %d", bleMan.isPausing);
    // narationCtrl 는 전과정 나레이션만 표시.
//    if (narationCtrl == nil) NSLog(@" narationCtrl == nil ");
//    else NSLog(@"  narationCtrl nil 아니고..  %d", narationCtrl.isPause);
    
    BOOL isPause = false;
    if (narationCtrl != nil) {
        [narationCtrl togglePause];
        isPause = narationCtrl.isPause;
    } //else        isPause = audioPlayer.player.isPlaying;

    NSLog(@"  isPause : %d   ", isPause);

    if (bleMan.isPausing) { // 이건 오디오와 상관있으므로..
        [_bttnPause setImage:[UIImage imageNamed:@"btn_unpause"] forState:UIControlStateNormal];
        [audioPlayer pause];
        [audioCount pause];
        [dObj.operationTimer forcePause];

        NSLog(@"  포즈 : 시작...");

        [bleMan.calcManager.compHoldTimer forcePause]; // 160307
        if (bleMan.bleState == S_STEPBYSTEP_BREATH || bleMan.bleState == S_STEPBYSTEP_COMPRESSION) [bleMan operationStop];
    } else {
        [_bttnPause setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
        [audioPlayer unpause];
        [bleMan.calcManager.compHoldTimer startOrReleaseToggle]; // 160307
        if (audioCount) [audioCount unpause];
        //if (  (bleMan.bleState == S_STEPBYSTEP_BREATH || bleMan.bleState == S_STEPBYSTEP_COMPRESSION) &&
        if (  bleMan.isOperatingState && ![arrCompBrthStt.curState.name isEqualToString:@"PrepareState"]) {
            [bleMan operationStart];
            [dObj.operationTimer startOrReleaseToggle];
        }
    }
}


// 재실행 하면 직전 명령 수행. Step by Step 모드에서만...  Skip ..
- (IBAction)retry:(id)sender {
    [log logUiAction:@"retry  또는 skip" lnum:2 printOn:true];
    if (bleMan.bleState == S_WHOLESTEP_DESCRIPTION) {
        [self startWholeInOneProcessWithCompression];
    } // 초반 skip 해라..
    if (bleMan.bleState == S_WHOLESTEP_AED) {
        bleMan.bleState = S_WHOLESTEP_RESULT;
        [skipLastAED doSetValue:true];
    }
    if (stepRetryMethod) { stepRetryMethod(); }
}

- (IBAction)goToMain:(id)sender {
    [log logUiAction:@"goToMain" lnum:2 printOn:true];
    [self goToMainAlertView];
}
#pragma mark -  bypassModeChangedAction
- (void)bypassModeChangedAction {
    [log logThis:@"bypassModeChangedAction" lnum:2];
    [self setManikinImage];
    if (bleMan.parsingState == AllInOne10) {
        for (int k = 0; k< arrButtons.count; k++) {
            [arrButtons[k] removeFromSuperview];
        }
    } else {
        [self setHeaderButtons];
    }
}

//////////////////////////////////////////////////////////////////////     _//////////_     [ AllInOneInitProcess         << >> ]    _//////////_  전과정 연속되는 프로세스..
#pragma mark - All in one process ..
- (void)AllInOneInitProcess {
    [log printThisFunc:@"AllInOneInitProcess" lnum:5];

    [_lblSignalMsg hideMe];
    [self uiInitialize];
    [self commonStartAction:true];

    //[_bttnRetrySkip.layer removeAllAnimations];

    if (_bttnRetrySkip.tag == 1) {
        [UIView animateWithDuration:0.001 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
            _bttnRetrySkip.transform = CGAffineTransformMakeTranslation(-1, 0);
            //code with animation
        } completion:^(BOOL finished) {
            self.bttnRetrySkip.tag = 0;
            //code for completion
        }];
    }
    showAEDAction = false;
    skipLastAED = [[HtNullableBool alloc] init];
    
    if (isBypassMode) {  // 세 버튼을 숨기냐 마냐...
        _bttnGoHome.hidden = _bttnPause.hidden = _bttnRetrySkip.hidden = true;
    } else { _bttnGoHome.hidden = _bttnPause.hidden = _bttnRetrySkip.hidden = false; }

    [_bttnRetrySkip setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
    [bleMan startWholeInOneProcess]; // 여기서 stage, calcManager 초기화 등..
    [self setSpeedLogic];
    [self narationSetting];
    [log endFunctionLog];
}

- (void)narationSetting {
    [self logCallerMethodwith:@" 전과정** Naration Play start .." newLine:2];
    [_imgVwMiddleMessage hideMe]; //_imgVwMiddleMessage.hidden = true;
    [_viewGraphMarkComp hideMe];
    [_viewGraphMarkBrth hideMe];
    [_progForce hideMe];

    narationCtrl = [[HtPauseCtrlTimer alloc] init];
    [spdLgc hideOrShowAll:false];
    
    [self.backgroundImageView setImage:[UIImage imageNamed:@"bg_officee_scenario.jpg"]];
        [self playAudio:@"school" isStepCase:false];

    __weak typeof(self) wself = self;
    [narationCtrl addJob:9 pAct: ^{
        NSLog(@" 전과정** 이미지 교체 :: bg_officee_scenario_2.jpg");
        [wself.backgroundImageView setImage:[UIImage imageNamed:@"bg_officee_scenario2.jpg"]];
    }];
    [narationCtrl addJob:12 pAct: ^{
        NSLog(@" 전과정** 이미지 교체 :: bg_officee_scenario_3.jpg");
        [wself.backgroundImageView setImage:[UIImage imageNamed:@"bg_officee_scenario3.jpg"]];
    }];
    [narationCtrl addJob:22 pAct: ^{
        NSLog(@" 전과정**  startWholeInOneProcessWithCompression  ");
        [wself startWholeInOneProcessWithCompression];
    }];
}

- (void)startWholeInOneProcessWithCompression {
    [log printThisFunc:@"startWholeInOneProcessWithCompression" lnum:5];
    narationCtrl = nil;
    bleMan.stage = 1;
    
    NSLog(@"\n\n\n       StepByStepTrialViewController     ::       startWholeInOneProcessWithCompression      stage = 1   \n\n\n");
    dObj.count = 0;

    [_lblCycle hideMe];  [_heartImageView hideMe]; [_labelCompBreath hideMe];
    _bttnPause.hidden = true;
    _bttnRetrySkip.hidden = true;
    _viewWholeInOne.hidden = _viewWholeInOne4Rescure.hidden = false;

    [self setSignalView];

    [self setManikinImage];
    [self startCompression];
    [log endFunctionLog];
}

//////////////////////////////////////////////////////////////////////     _//////////_     [ UI || UX         << >> ]    _//////////_   uiUpdateAction
//////////////////////////////////////////////////////////////////////     _//////////_     [ UI || UX         << >> ]    _//////////_   uiUpdateAction
//////////////////////////////////////////////////////////////////////     _//////////_     [ UI || UX         << >> ]    _//////////_   uiUpdateAction
#pragma mark - UI / UX
/// 호흡 메시지 표시...  0.4초 후 꺼짐...
- (void)imgSignTurnOn {
    //if (!(_imgMsgGood.hidden && _imgMsgWeak.hidden && _imgVwMsgUp.hidden && _imgVwMsgDn.hidden        && [bleMan uiMessageOn]))
    if (!(bleMan.bleState == S_STEPBYSTEP_BREATH || bleMan.bleState == S_WHOLESTEP_BREATH) || ![bleMan uiMessageOn])
        return;
    //NSLog(@"\n\n  호흡 사인 관련 >>  imsSignTurn On    msgName :: %@  \n", bleMan.messageName);
    NSString *msgName = bleMan.messageName;
    UIImageView *curImg = nil;
    _imgSlowFastSign.image = [UIImage imageNamed:msgName];
    _imgSlowFastSign.hidden = false;
}

- (void)imgSignTurnOff {
    if (!(bleMan.bleState == S_STEPBYSTEP_BREATH || bleMan.bleState == S_WHOLESTEP_BREATH))
        return;
    //NSLog(@"  호흡 사인 관련 >>  imsSignTurn Off ");
    if (!_imgSlowFastSign.hidden && [bleMan uiMessageOff]) {
        _imgSlowFastSign.hidden = true;
    }
}

- (BOOL)startedWithWeakOrWrongPosition {
    NSString *msgName = bleMan.messageName;
    return false;
}

//////////////////////////////////////////////////////////////////////     _//////////_     [ << Update >> ]    _//////////_
#pragma mark -  uiUpdateAction
- (void)uiUpdateAction {
//    if (5 < depth + amount) { NSLog(@"StepByStepTrialVC  ___________5 < depth + amount___________   stage : %d  ___________  curStep : %d  (11/12) ___________  depth,amount : %d, %d   count : %d   hidden ? %d",
//                                   bleMan.stage, currentStep, depth, amount, count, _imgVwMsgUp.isHidden); }
    [curStepWatch setInitValueTo:false];
    [curStepWatch compareThis_Once:(int)bleMan.bleState willPrint:true]; // 비교 한번...
    
    [self checkHardware];

    // debugging  실시간 캘리 관련..
//    HsCalcManager* calc = bleMan.calcManager;
//    _labelTime.text = [NSString stringWithFormat:@"%@   Sta : %ld   Limit %ld   D/F %f /%ld  raw : %ld", lObj.timer,
//                       (long)calc.myStaPo, (long)calc.myLimitPo, calc.caliTempDepth, calc.caliTempForce,
//                       (long)((calc.realCali.rawCali - 20) / 32)];

 
    // 화살표 표시.
    if ([HsUtil isComp:bleMan.bleState]) [self setArrowImages]; // 압박일 때만 실행.

    if (bleMan.bleState == S_STEPBYSTEP_COMPRESSION || bleMan.bleState == S_WHOLESTEP_COMPRESSION)
        bleMan.calcManager.data.isMessageDone = false;
    
    // 프로그레스 표시.
    //[_progressView setProgress:[bleMan progressValue4Display] animated:NO];

    [_progForce setProgress:[bleMan progressValue4Display]];

    [_progressCount setProgress:[bleMan progressValue4Counter] animated:NO];
    
    [self setCounterAndWatch];
    
    [arrCompBrthStt update];
    
    // 경고 이미지 켜고 끄기.

    [self imgSignTurnOff];
    [self imgSignTurnOn];

    // 압박 중단 시간 표시...
    [holdingTimeView update];
    
    // ////////////////  ________________________________________ <<<<<<<<<  whole in one 에서만 해당.   >>>>>>
    if (bleMan.parsingState != AllInOne10) return;
    
    if (narationCtrl != nil) {
        [narationCtrl updateJob];
    }

    if ([skipLastAED validAndTrue] && !skipLastAED.didDoneMainJob) {
        NSLog(@"  skipLastAED validAndTrue   skipLastAED.didDoneMainJob  showResultView .....  신호등을 스킵한다.   ");
        [resultViewTimer cancel];
        [self showResultView];
        [skipLastAED didMainJob];
    }

    _lblCycle.text = [NSString stringWithFormat:@"%d / %d", bleMan.stage, HsBleSingle.inst.stageLimit];
    
    if (bleMan.bleState == S_WHOLESTEP_AED && showAEDAction == false) { // 모든 프로세스 후 종료 화면으로
        showAEDAction = true;
        [self finalProcess];
        skipLastAED.value = false; // isSet = true 가 됨..
        [self commonStartAction:true]; // 매 단계 시작시 불리는 UI 세팅 함수..
        return;   //  과정이 끝나면 이 이하는 실행하지 않음...
    }
    
    if (bleMan.bleState == S_WHOLESTEP_AED || bleMan.bleState == S_WHOLESTEP_RESULT)  return;
    
    if (curStepWatch.isChanged) { // 압박 <--> 호흡 전환.
        if (bleMan.bleState == S_WHOLESTEP_BREATH)
            [self startBreathProcess];
        if (bleMan.bleState == S_WHOLESTEP_COMPRESSION)
            [self startCompression];
    }
    
    if (dObj.count > 0 && !_viewWholeInOne.isHidden) {
        //_viewCompImgs.hidden = false;
        _viewWholeInOne.hidden = _viewWholeInOne4Rescure.hidden = true;
    }
}


//////////////////////////////////////////////////////////////////////     _//////////_     [   센서 연결 유실  메시지....  << >> ]    _//////////_
#pragma mark -  센서 연결 유실  메시지...
- (void)checkHardware {
    if (!bleMan.isConnected) { // 접속이 끊어지면...
        NSLog(@"\n\n\n\n\n  트레이너 오퍼레이션..  DisConnected   \n\n\n\n\n");
        [self showAlertPopupOfGoHome];
        [uiTimer invalidate];
        //[self.navigationController popToRootViewControllerAnimated:true]; // 끊어지면 루트로..
    }
    
    NSString *msg = [bleMan.stateMan sensorStateCheck]; // 패드, 호흡 모듈 ..  등이 옴..
    //if ([msg isEqualToString:@"OK"]) return;
    if (msg == nil) return;
    
    if (sensorLostAlertView != nil && sensorLostAlertView.isHidden == false)   return;
    
    //msg = [NSString stringWithFormat:@"%@ %@", msg, [self local Str:@"sensor_not_connected"]];
    sensorLostAlertView = [[PSPDFAlertView alloc] initWithTitle:[bleMan.stateMan errorString] message:msg];
    sensorLostAlertView.alertViewStyle = UIAlertViewStyleDefault;
    __weak typeof(self) weakSelf = self;
    [sensorLostAlertView setCancelButtonWithTitle:
     lObj.confirm block:^(NSInteger buttonIndex){
         if (bleMan.parsingState == AllInOne10) {
             NSLog(@"  checkHardware >>  startWholeInOneProcessWithCompression   ");
             [weakSelf startWholeInOneProcessWithCompression];             // 신호등 화면으로 전환
         } else {
             stepRetryMethod();
         }
         sensorLostAlertView = nil;
     }];
    
    [sensorLostAlertView show];
    
}

- (void)uiProgressCounterTimeHide:(BOOL)hide {
    _labelTime.hidden = hide;
    _timerLabel.hidden = hide;
    _labelExplain.hidden = hide;

    //_progressView.hidden = hide;

    _viewGraphMarkBrth.hidden = hide;
    _viewGraphMarkComp.hidden = hide;
    _progForce.hidden = hide;

    _progressCount.hidden = hide;
    _labelTryNum.hidden = hide;
    _labelCount.hidden = hide;
    _counterLabel.hidden = hide;
    [_progForce setProgress:0.f];

    if (bleMan.parsingState == AllInOne10) {
        _labelCount.hidden = true;
        _counterLabel.hidden = true;
    } else {
        _labelTryNum.hidden = true;
        _progressCount.hidden = true;
    }
}

- (void)setArrowImages {
    [_imgArrow1 setHidden: true]; [_imgArrow2 setHidden: true]; [_imgArrow3 setHidden: true]; [_imgArrow4 setHidden: true];
    if (dObj.isCorrectPosition)         return; // 정상이면 스킵.
    //NSLog(@"  Index : %d, %d, %d, %d", imgIdx1, imgIdx2, imgIdx3, imgIdx4);
    [_imgArrow1 setHidden: [bleMan.calcManager hideArrow:1]];
    [_imgArrow2 setHidden: [bleMan.calcManager hideArrow:2]];
    [_imgArrow3 setHidden: [bleMan.calcManager hideArrow:3]];
    [_imgArrow4 setHidden: [bleMan.calcManager hideArrow:4]];
    //NSLog(@"  isHidden ? %d, %d, %d, %d", _imgArrow1.isHidden, _imgArrow2.isHidden, _imgArrow3.isHidden, _imgArrow4.isHidden);
}

- (void)goToMainAlertView {
    PSPDFAlertView *alert =
    [[PSPDFAlertView alloc] initWithTitle:lObj.to_main message:lObj.want_main];
    [self pauseAction];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert setCancelButtonWithTitle:lObj.yes
                              block: ^(NSInteger buttonIndex) {
                                  self->bleMan.bleState = S_READY; // 이게 애니메이션이 없으니 안보였슴..  바이패스와 결함 시 오작동 버그.. 160706
                                  [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated: viewAnimate];
                              }];
    [alert addButtonWithTitle:lObj.no block:^(NSInteger buttonIndex) {
        [self pauseAction];
    }];

    [alert show];
}

- (void)setCounterAndWatch {   ///  압박 | 호흡   에 따라 카운터 조절. ...  15 / 30  ||   1 / 2
    if ([HsUtil isComp:bleMan.bleState]) {
        //_counterLabel.text = [NSString stringWithFormat:@" %d / %d", dObj.ccCorCount, dObj.count]; // 카운터.
        _counterLabel.text = [NSString stringWithFormat:@" %ld", (long)dObj.count]; // 카운터. 그냥 전체 카운트만
        [_countProgressView setProgress:( dObj.count / 30.0f) animated:NO];
    } else {
        //_counterLabel.text = [NSString stringWithFormat:@" %d / %d", dObj.rpCorCount, dObj.count]; // 카운터.
        _counterLabel.text = [NSString stringWithFormat:@" %ld", (long)dObj.count]; // 카운터.
        [_countProgressView setProgress:(dObj.count / 2.0f) animated:NO];
    }
    _timerLabel.text = [dObj.operationTimer timeMMSSHH];
}

- (void)audioStop {
    [audioCount reset];
    [audioPlayer reset];
    //if (audioCount && audioCount.player.isPlaying) { [audioCount stop];  audioCount = nil; }
    //if (audioPlayer && audioPlayer.player.isPlaying) { [audioPlayer stop];  audioPlayer = nil; }
}


//////////////////////////////////////////////////////////////////////     _//////////_     [   연습 시작..  << >> ]    _//////////_
#pragma mark -  UI 초기화 ...   Sub 함수들..

- (void)uiInitialize {
    if (resultViewTimer) [resultViewTimer cancel];
    [self audioStop];
    //_imgCenterCircle.highlighted = true; _imgVwMsgUp.hidden = true;  _imgMsgGood.hidden = true;
    _imgVwMsgDn.hidden = true;

    holdingTimeView.hidden = true;
    [self turnOffSignals];
    
    [self uiProgressCounterTimeHide:true];  //_labelCompBreath.hidden = true;_heartImageView.hidden = true;signalView.hidden = true;
}

- (void)turnOffSignals {  // 신호등, 사이클 라벨, 하트 이미지 등 끄기.
    signalVw.hidden = true;
    _labelCompBreath.hidden = true;  _lblCycle.hidden = true; _heartImageView.hidden = true;
}

- (void)infoImageHideInBypass {
    if (isBypassMode) [_btnInfo hideMe];
    else [_btnInfo showMe];
}

- (void)commonStartAction:(BOOL)hideProgress { // 매 단계 시작시 불리는 UI 세팅 함수..
    if (bleMan.isPausing) [self pauseAction];
    [self infoImageHideInBypass];

    /// 스피드 관련 메시지 들...
    [spdLgc hideOrShowAll:false];

    //_imgVwMiddleMessage.hidden = true;
    _viewCompImgs.hidden =  true; // 화살표 이미지 등 끄기.
    
    [self uiProgressCounterTimeHide:hideProgress]; //    //ProgressSetting
}

//////////////////////////////////////////////////////////////////////     _//////////_     [   연습 시작..  << >> ]    _//////////_
#pragma mark -  각 버튼   시작...  start Compression, Breath ...
- (void)startCompression {
    [self logCallerMethodwith:@"   startCompression   " newLine:1];
    [self audioStop];


    showResultView = false;

    [self commonStartAction:(bleMan.parsingState == AllInOne10)];

    [_viewGraphMarkBrth hideMe];
//    [_viewGraphMarkComp showMe];
    //_progressView.primaryColors = hsGlb4Colr.foreGrndColors;  // foregroundColors;
    //_progressView.secondaryColors = hsGlb4Colr.backGrndColors;

    [self setManikinImage]; // 전과정 스킵할 때..
    [bleMan startCompressionProcess];
    
    _labelExplain.text = lObj.compression_depth; // "compression_depth" = "압박 깊이";
    _labelCompBreath.text = lObj.compression; // [self locr:@"compression_simple"];
    
    __weak typeof(self) weakSelf = self;
    stepRetryMethod = ^{ [weakSelf startCompression]; }; //pageType = CompressionType;
    /*     button 활성화 셋팅     */
    [self setButtonView:26];

    arrCompBrthStt = [[HtGeneralStateManager alloc] init];
    HtUnitState *aState = [[HtUnitState alloc]initWithDuTime:-1  myName:@"PrepareState"]; // Prepare State..
    aState.entryAction = ^{
        if (bleMan.parsingState == StepByStep20) {
            /// 스피드 관련 메시지 들...
            [spdLgc hideOrShowAll:true];
            [spdLgc deactivateAll];
            [_imgVwMiddleMessage showMe]; // 설명 이미지..
        }
        //  ////    메인 이미지를 변경한다.
        [_imgVwInfo setImageWith:@"pic_info_compression"];  //[_infoImageView setImage:[UIImage imageNamed:@"pic_info_compression"]];
        _titleLabel.text = lObj.compression;
        _descriptionLabel.text = lObj.compression_info_txt;

        //  ////  나레이션 플레이.
        [self playAudio:@"compression" isStepCase:true];

        //  ////  메트로놈 소리.....
        NSString *path = [NSString stringWithFormat:@"%@/AudioFiles/compression_guide.mp3", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        //audioCount = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        audioCount = [[HtAudioPlayer alloc] initWithRepeatLimit:-1 url:soundUrl];
        if (!isBypassMode && bleMan.parsingState != AllInOne10)
            [audioPlayer play];  //[audioCount play]; // 이건 리플레이가 되므로 없어도 됨..
        [dObj.operationTimer resetTime];
        [dObj.operationTimer forcePause];
        //aState.exittAction = ^{ [dObj.operationTimer pause]; };
    };
    aState.durinAction = ^ {
        [self countAudioReplay];
    };
    aState.exitCondition = ^BOOL{ return dObj.depth > 20 || dObj.count > 0 || [self startedWithWeakOrWrongPosition] ||
        (bleMan.parsingState == AllInOne10 && 1 < bleMan.calcManager.stage); };
    [arrCompBrthStt addAState:aState];
    
    aState = [[HtUnitState alloc]initWithDuTime:-1  myName:@"MainCompression"]; // Compression State
    aState.entryAction = ^{
        [dObj.operationTimer startOrReleaseToggle];
        //151202 [uiStopWatch resetTime];
        _viewCompImgs.hidden = false; // 중심 원, 화살표등 이미지 등 켜기..
        _imgVwMiddleMessage.hidden = true;
        [_timerLabel setHidden:NO];  //timer 보이기.
        [self uiProgressCounterTimeHide:false]; //ProgressSetting 보이기.
        [_viewGraphMarkBrth hideMe];

        // 신호등 끄기
        _viewWholeInOne.hidden = _viewWholeInOne4Rescure.hidden = true;
        
        [audioPlayer stop];
        if (audioCount && !audioCount.playing && !isBypassMode) { [audioCount play]; } // 연속해서 플레이.
        
        if (bleMan.parsingState == AllInOne10) {
            signalVw.hidden = true;
            _lblSignalMsg.hidden = true;

            /// 스피드 관련 메시지 들...
            [spdLgc hideOrShowAll:true];
            [spdLgc deactivateAll];

            [_lblCycle showMe];  [_heartImageView showMe]; [_labelCompBreath showMe];
            [HsGlobal delay:3.0 closure:^{
                _imgVwMiddleMessage.hidden = true;
            }];
        } else {
            _progressCount.hidden = true;
            _imgVwMiddleMessage.hidden = true;
            //_viewCompImgs.hidden = false;
        }
    };
    aState.durinAction = ^ {
        signalVw.hidden = true; // 이거는 중복인데..  혹시 몰라서...
        [self setManikinImage]; // 상태(health)에 따라 이미지 변경.
        [self countAudioReplay];
    };
    aState.exitCondition = ^BOOL{ return false; };
    [arrCompBrthStt addAState:aState];
    [arrCompBrthStt prepareActions];
}

- (void)countAudioReplay {
    if (bleMan.isPausing || isBypassMode)
        return; // (bleMan.parsingState == AllInOne10 && 1 < bleMan.calcManager.stage);
    if (bleMan.parsingState == AllInOne10 && bleMan.calcManager.stage == 1) return;

    if (!audioCount.playing) { [audioCount play]; }
}

//////////////////////////////////////////////////////////////////////     _//////////_     [   호흡..  << >> ]    _//////////_
- (void)startBreathProcess {
    [self logCallerMethodwith:@" 인공 호흡 시작.. " newLine:1];
    [self commonStartAction:false];
    [self audioStop];

    //_progressView.primaryColors = hsGlb4Colr.rpForeGrndColors;  // foregroundColors;
    //_progressView.secondaryColors = hsGlb4Colr.rpBackGrndColors;
    
    __weak typeof(self) weakSelf = self;
    stepRetryMethod = ^{ [weakSelf startBreathProcess]; };
    [bleMan startStepBreathProcess];
    
    /*     button 활성화 셋팅     */
    [self setButtonView:27];

    _labelExplain.text = lObj.breath_volume; //  [self lStr:@"Respiration_amount"]; // "compression_depth" = "압박 깊이";    "Respiration_amount" = "호흡량";
    _labelCompBreath.text = lObj.breath; // [self lStr:@"respiration_simple"];
    
    arrCompBrthStt = [[HtGeneralStateManager alloc] init];
    HtUnitState *aState = [[HtUnitState alloc]initWithDuTime:-1  myName:@"PrepareState"]; // Prepare State..
    aState.entryAction = ^{
        if (bleMan.parsingState != AllInOne10) {
            _imgVwMiddleMessage.hidden = false; // 설명 이미지..
            [dObj.operationTimer resetTime];
            [dObj.operationTimer forcePause];
        }

        //  ////    메인 이미지를 변경한다.
        [_imgVwInfo setImageWith:@"pic_info_breath"]; //[_infoImageView setImage:[UIImage imageNamed:@"pic_info_breath"]];

        _titleLabel.text = lObj.respiration_info_title;
        _descriptionLabel.text = lObj.respiration_info_txt;

        //  ////  나레이션 플레이.
        [self playAudio:@"breath" isStepCase:true];


    };
    aState.exitCondition = ^BOOL{ return dObj.amount > 20 || dObj.count > 0; };
    [arrCompBrthStt addAState:aState];
    
    aState = [[HtUnitState alloc]initWithDuTime:-1  myName:@"MainCompression"]; // Compression State
    aState.entryAction = ^{
        [dObj.operationTimer startOrReleaseToggle];
        _imgVwMiddleMessage.hidden = true;
        //timer 보이기.
        [_timerLabel setHidden:NO];
        //ProgressSetting 보이기.
        [self uiProgressCounterTimeHide:false];
        [_viewGraphMarkComp hideMe];


        
        [audioPlayer stop];
        //if (audioCount && !audioCount.player.isPlaying && !isBypassMode) { [audioCount play]; } // 연속해서 플레이.
        if (bleMan.parsingState == AllInOne10)
            ; //[_progressCount setNumberOfSegments:120];
        else
            _progressCount.hidden = true;
    };
    aState.exitCondition = ^BOOL{ return false; };
    [arrCompBrthStt addAState:aState];
    [arrCompBrthStt prepareActions];
}

//////////////////////////////////////////////////////////////////////     _//////////_     [   전과정 최종..  << 신호등/AED >> ]    _//////////_
#pragma mark -  전과정 최종 관련
- (void)finalProcess {
    [self logCallerMethodwith:@" 신호등 띄우고.. 결과화면은 좀 있다.. " newLine:5];
    [self uiInitialize];

    arrCompBrthStt = nil; // 이거 없으면 압박 엔트리로 들어가서 오작동..

    [bleMan operationStop];

    _viewWholeInOne.hidden = _viewWholeInOne4Rescure.hidden = false;
    if (!isBypassMode)
        _bttnRetrySkip.hidden = false;  // 스킵 버튼 다시 표시. 포즈 버튼은 숨김..

    [UIView animateWithDuration:0.001 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        _bttnRetrySkip.transform = CGAffineTransformMakeTranslation(80, 0);
        //code with animation
    } completion:^(BOOL finished) {
        self.bttnRetrySkip.tag = 1;
        //code for completion
    }];

    signalVw.hidden = false;
    [signalVw setFinalAnimation];

    resultViewTimer = [[HtDelayTimer alloc] init];
    [resultViewTimer setDelay:7.0 closure:^{
        NSLog(@"  skipLastAED ?  %d   %d ", skipLastAED.validAndTrue, skipLastAED.didDoneMainJob  );
        if (skipLastAED.validAndTrue && skipLastAED.didDoneMainJob)
            return;
        [self showResultView];
    }];
}

- (void)showResultView {
    if (showResultView)
        return;
    else
        showResultView = true;

    NSLog(@" 결과 화면 띄우기... ");

    bleMan.bleState = S_WHOLESTEP_RESULT;
    ResultVC* vc = [[ResultVC alloc] initWithNibName:@"ResultVC" bundle: nil];

    signalVw.hidden = true;
    [self uiProgressCounterTimeHide:true];

    vc.gotoMainClj = ^ { //[self goToMainAlertView]; };  // 바이패스 모드에서 달라져야...
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated: viewAnimate];
    };

    vc.repeatClj =  ^ {  [self AllInOneInitProcess];  }; //  [self AllInOneInitProcess];  이거 필요 없슴..

    vc.view.frame = CGRectMake(0,0, 1024, 768); //Your own CGRect
    [self.view addSubview:vc.view];

    [self addChildViewController:vc];
    [self didMoveToParentViewController:vc];

    [self.navigationController addChildViewController:vc];
    [self.navigationController didMoveToParentViewController:vc];
}

- (void)showResuxltViewx {
    bleMan.bleState = S_WHOLESTEP_RESULT;
    ResultVC* vc = [[ResultVC alloc] initWithNibName:@"ResultVC" bundle: nil];

    vc.gotoMainClj = ^ { //[self goToMainAlertView]; };  // 바이패스 모드에서 달라져야...
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated: viewAnimate];
    };

    vc.repeatClj =  ^ {  }; //  [self AllInOneInitProcess];  이거 필요 없슴..
    [self presentViewController:vc animated:viewAnimate completion:^{     }];
}


//////////////////////////////////////////////////////////////////////     _//////////_     [   연습 시작..  << >> ]    _//////////_
#pragma mark -  각 버튼   시작...  start setResponse
- (void)setSafety {
    [self logCallerMethodwith:@" setSafety " newLine:1];
    [self commonStartAction:true];
    [self audioStop];
    arrCompBrthStt = nil;
    [bleMan operationStop];

    __weak typeof(self) weakSelf = self;
    stepRetryMethod = ^{ [weakSelf setSafety]; };

    [self playAudio:@"checkdanger" isStepCase:true];

    /*     * 이미지를 변경한다.     */
    [_imgVwInfo setImageWith:@"pic_info_checkdanger"]; //    [_infoImageView setImage:[UIImage imageNamed:@"pic_info_checkdanger"]];
    [self setButtonView:21];

    _titleLabel.text = lObj.check_danger_info_title;
    _descriptionLabel.text = lObj.check_danger_info_txt;
    _imgVwMiddleMessage.hidden = (bleMan.parsingState == AllInOne10); // 올인원에서는 숨김
}

- (void)setAirWay {
    [self logCallerMethodwith:@" setAirWay " newLine:1];
    [self commonStartAction:true];
    [self audioStop];
    arrCompBrthStt = nil;
    [bleMan operationStop];

    __weak typeof(self) weakSelf = self;
    stepRetryMethod = ^{ [weakSelf setAirWay]; };

    [self playAudio:@"airway" isStepCase:true];

    /*     * 이미지를 변경한다.     */
    [_imgVwInfo setImageWith:@"pic_info_airway.png"];//    [_infoImageView setImage:[UIImage imageNamed:@"pic_info_airway.png"]];
    [self setButtonView:23];

    _titleLabel.text = lObj.open_airway_info_title;
    _descriptionLabel.text = lObj.open_airway_info_txt;
    _imgVwMiddleMessage.hidden = (bleMan.parsingState == AllInOne10); // 올인원에서는 숨김

}

- (void)setCheckBreath {
    [self logCallerMethodwith:@" setCheckBreath " newLine:1];
    [self commonStartAction:true];
    [self audioStop];
    arrCompBrthStt = nil;
    [bleMan operationStop];

    __weak typeof(self) weakSelf = self;
    stepRetryMethod = ^{ [weakSelf setCheckBreath]; };

    [self playAudio:@"checkbreath" isStepCase:true];

    /*     * 이미지를 변경한다.     */
    [_imgVwInfo setImageWith:@"pic_info_checkbreath.png"]; //     [_infoImageView setImage:[UIImage imageNamed:@"pic_info_checkbreath.png"]];
    [self setButtonView:24];

    _titleLabel.text = lObj.check_breath_info_title;
    _descriptionLabel.text = lObj.check_breath_info_txt;
    _imgVwMiddleMessage.hidden = (bleMan.parsingState == AllInOne10); // 올인원에서는 숨김
}

- (void)setResponse {
    [self logCallerMethodwith:@" setResponse " newLine:1];
    [self commonStartAction:true];
    [self audioStop];
    arrCompBrthStt = nil;
    [bleMan operationStop];
    
    __weak typeof(self) weakSelf = self;
    stepRetryMethod = ^{ [weakSelf setResponse]; };     //pageType = ResponseType;

    [self playAudio:@"response" isStepCase:true];

    /*     * 이미지를 변경한다.     */
    [_imgVwInfo setImageWith:@"pic_info_awareness"]; //    [_infoImageView setImage:[UIImage imageNamed:@"pic_info_awareness"]];
    [self setButtonView:22];

    _titleLabel.text = lObj.response_info_title;
    _descriptionLabel.text = lObj.response_info_txt;
    _imgVwMiddleMessage.hidden = (bleMan.parsingState == AllInOne10); // 올인원에서는 숨김
}

- (void)playAudio:(NSString*)filename isStepCase:(BOOL)step {
    NSString* langS = @"_kr";
    switch (langIdx) {
        case 0:
            langS = @"_en";
            if (HsBleSingle.inst.cprProto.theVal == 2 && step)
                langS = @"_anz";
            break;
        case 1: langS = @"_kr"; break;
        case 2: langS = @"_de"; break;
        case 3: langS = @"_fr"; break;
        default: langS = @"_es"; break;
    }
    NSString *fileName = [NSString stringWithFormat:@"%@/AudioFiles/%@%@.mp3",
                          [[NSBundle mainBundle] resourcePath], filename, langS];
    NSLog(@" audio : %@", fileName);
    NSString *path = [NSString stringWithFormat:fileName, [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    //audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    audioPlayer = [[HtAudioPlayer alloc] initWithRepeatLimit:1 url:soundUrl];
    if (!isBypassMode) {
        [audioPlayer play];
    }
}

- (void)setEmergency {
    [self logCallerMethodwith:@"  " newLine:1];
    [self commonStartAction:true];
    [self audioStop];
    arrCompBrthStt = nil;
    [bleMan operationStop];
    
    __weak typeof(self) weakSelf = self;
    stepRetryMethod = ^{ [weakSelf setEmergency]; }; //   pageType = EmergencyType;
    
    //  * 기존 재생되던 소리를 멈춘다.
    [self playAudio:@"emergency" isStepCase:true];

    [_imgVwInfo setImageWith:@"pic_info_emergency"]; //  [_infoImageView setImage:[UIImage imageNamed:@"pic_info_emergency"]];
    [self setButtonView:25];

    _titleLabel.text = lObj.emergency_info_title;
    _descriptionLabel.text = lObj.emergency_info_txt;

    _imgVwMiddleMessage.hidden = (bleMan.parsingState == AllInOne10); // 올인원에서는 숨김
}

- (void)setCheckPulse {
    [self logCallerMethodwith:@"  " newLine:1];
    [self commonStartAction:true];
    [self audioStop];
    arrCompBrthStt = nil;
    [bleMan operationStop];
    
    __weak typeof(self) weakSelf = self;
    stepRetryMethod = ^{ [weakSelf setCheckPulse]; }; // pageType = CheckPulseType;
    
    //  * 기존 재생되던 소리를 멈춘다.
    [self playAudio:@"checkpulse" isStepCase:true];
    [self setButtonView:30];

    /*
     * 이미지를 변경한다.
     */
    [_imgVwInfo setImageWith:@"pic_info_pulsecheck"]; //  [_infoImageView setImage:[UIImage imageNamed:@"pic_info_pulsecheck"]];
    _titleLabel.text = lObj.pulsecheck_info_title;
    _descriptionLabel.text = lObj.pulsecheck_info_txt;
//    [_titleLabel setAttributedText:[HSAttributedString defaultStyleAttributedString:lObj.pulsecheck_info_title
//                                                                               font:fontTitle fontColor:COLOR_HS_BLACK]];
//    [_descriptionLabel setAttributedText:[HSAttributedString defaultStyleAttributedString:lObj.pulsecheck_info_txt
//                                                                                     font:fontContent fontColor:COLOR_HS_BLACK]];

    [_descriptionLabel setAutoresizesSubviews:YES];
    [_descriptionLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [_descriptionLabel setAutoresizesSubviews:YES];
    [_descriptionLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    _imgVwMiddleMessage.hidden = (bleMan.parsingState == AllInOne10); // 올인원에서는 숨김
}

- (void)setAED {
    [self logCallerMethodwith:@"  " newLine:1];
    [self commonStartAction:true];
    [self audioStop];
    arrCompBrthStt = nil;
    [bleMan operationStop];
    
    __weak typeof(self) weakSelf = self;
    stepRetryMethod = ^{ [weakSelf setAED]; }; //    pageType = AEDType;
    
    //  ////    기존 재생되던 소리를 멈춘다.
    [self playAudio:@"aed" isStepCase:true];

    aedIdx = 0;
    [_imgVwInfo setImageWith:@"pic_info_aed"]; //   [_infoImageView setImage:[UIImage imageNamed:@"pic_info_aed"]];
    [self setButtonView:28];

    _titleLabel.text = lObj.aed_info_title;
    _descriptionLabel.text = lObj.aed_infoTotalTxt;
    _imgVwMiddleMessage.hidden = (bleMan.parsingState == AllInOne10); // 올인원에서는 숨김
}

//////////////////////////////////////////////////////////////////////     _//////////_     [ 유럽 / 뉴질랜드 프로토콜 ..         << >> ]    _//////////_
- (void)setEuropeHeaderButtons {
    [self logCallerMethodwith:@"  " newLine:1];
    NSLog(@"  bypass >>> ?  %d,   rescure ? %d" , isBypassMode, isRescureMode);

    headerButtonsView = [[UIView alloc]init];
    if([self.view viewWithTag:5]) {
        headerButtonsView = (UIView*)[self.view viewWithTag:5];
    } else {
        [headerButtonsView setTag:5];
        [self.view addSubview:headerButtonsView];
    }
    arrButtons = [[NSMutableArray alloc] init];
    float scl = 1.3, iconScl = 1.7;
    NSMutableArray *arrStepImages = [[NSMutableArray alloc]init];
    CGFloat width = scl*50.f*8.f + scl*30.f*7.f;
    [headerButtonsView setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width / 2.f) - // 8개 버튼..
                                           (width/2.f), 0.f, width, scl * 47.f)];

    // tag : safety, resp, airway, checkBreath, emergency, comp, resp, aed   21 ...
    NSInteger tagArray[8] = { 21, 22, 23, 24, 25, 26, 27, 28 };
    // ((50.f*5.f + 30.f*4.f)/2.f), 0.f, 50.f*5.f + 30.f*4.f, 47.f)];
    [arrStepImages addObject:[UIImage imageNamed:@"menu_step_checkdanger"]];
    [arrStepImages addObject:[UIImage imageNamed:@"menu_step_response"]];
    if (HsBleSingle.inst.cprProto.theVal == 1) {
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_airway"]];
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_checkbreath"]];
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_emergency"]];
    } else {
        tagArray[2] = 25; // { 21, 22, 25, 23, 24, 26, 27, 28 };
        tagArray[3] = 23; tagArray[4] = 24;
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_emergency"]];
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_airway"]];
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_checkbreath"]];
    }
    [arrStepImages addObject:[UIImage imageNamed:@"menu_step_compression"]];
    [arrStepImages addObject:[UIImage imageNamed:@"menu_step_breath"]];
    [arrStepImages addObject:[UIImage imageNamed:@"menu_step_aed"]];

    for(int i = 0; i < 8; i++){
        UIButton *bt = [[UIButton alloc] init]; // 버튼 생성.......
        [bt setTag:tagArray[i]]; //  //[bt setTag:10 + i];  수정함..
        [bt setFrame:CGRectMake(scl*80.f*i, 0.f, iconScl*50.f, iconScl*47.f)]; // (80.f*i, 0.f, 50.f, 47.f)];  높이를 높여야..
        [bt setImage:[arrStepImages objectAtIndex:i] forState:UIControlStateNormal];
        [bt setBackgroundImage:[UIImage imageNamed:@"menu_step_gray_btn"] forState:UIControlStateNormal];
        if (!isBypassMode) // 바이패스가 아닐 때만 이벤트 추가.
            [bt addTarget:self action:@selector(stepButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [headerButtonsView addSubview:bt];
        [arrButtons addObject:bt];
        NSLog(@"  button 추가 : %d", i);
    }
}


//////////////////////////////////////////////////////////////////////     _//////////_     [ UI || UX         << >> ]    _//////////_
#pragma mark - 헤더 Button Setting...
- (void)setHeaderButtons {
    [self logCallerMethodwith:@"  " newLine:1];
    NSLog(@"  bypass >>> ?  %d,   rescure ? %d" , isBypassMode, isRescureMode);

    if (HsBleSingle.inst.cprProto.theVal != 0) {
        [self setEuropeHeaderButtons];
        return;
    }
    
    headerButtonsView = [[UIView alloc]init];
    if([self.view viewWithTag:5]){
        headerButtonsView = (UIView*)[self.view viewWithTag:5];
    } else {
        [headerButtonsView setTag:5];
        [self.view addSubview:headerButtonsView];
    }
    arrButtons = [[NSMutableArray alloc] init];
    float scl = 1.5, iconScl = 2.0;
    NSMutableArray *arrStepImages = [[NSMutableArray alloc]init];
    
    if(isRescureMode) {
        [headerButtonsView setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width/2.f) -
                                               ((scl*50.f*5.f + scl*30.f*4.f)/2.f), 0.f, scl*(50.f*5.f + 30.f*4.f), scl*47.f)];

        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_response"]];
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_emergency"]];
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_compression"]];
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_breath"]];
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_aed"]];

        NSInteger tagArray[5] = { 22, 25, 26, 27, 28 };
        for(int i=0; i<5; i++){
            UIButton *bt = [[UIButton alloc]init];
            [bt setTag:tagArray[i]]; // [bt setTag:10+i];
            [bt setFrame:CGRectMake(scl*80.f*i, 0.f, iconScl*50.f, iconScl*47.f)]; // (80.f*i, 0.f, 50.f, 47.f)];  높이를 높여야..
            [bt setImage:[arrStepImages objectAtIndex:i] forState:UIControlStateNormal];
            [bt setBackgroundImage:[UIImage imageNamed:@"menu_step_gray_btn"] forState:UIControlStateNormal];
            if (!isBypassMode) // 바이패스가 아닐 때만 이벤트 추가.
                [bt addTarget:self action:@selector(stepButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [headerButtonsView addSubview:bt];
            [arrButtons addObject:bt];
        }
        return;
    } else {
        [headerButtonsView setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width/2.f) - ((scl*50.f*6.f + scl*30.f*5.f)/2.f), 0.f,
                                               scl*(50.f*6.f + 30.f*5.f), scl*47.f)];
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_response"]];
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_emergency"]];
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_checkpulse"]];
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_compression"]];
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_breath"]];
        [arrStepImages addObject:[UIImage imageNamed:@"menu_step_aed"]];

        NSInteger tagArray[6] = { 22, 25, 30, 26, 27, 28 };
        for(int i=0; i<6; i++){
            UIButton *bt = [[UIButton alloc]init];
            [bt setTag:tagArray[i]]; // [bt setTag:10+i];
            [bt setFrame:CGRectMake(scl*80.f*i, 0.f, iconScl*50.f, iconScl*47.f)];
            [bt setImage:[arrStepImages objectAtIndex:i] forState:UIControlStateNormal];
            [bt setBackgroundImage:[UIImage imageNamed:@"menu_step_gray_btn"] forState:UIControlStateNormal];
            if (!isBypassMode) // 바이패스가 아닐 때만 이벤트 추가.
                [bt addTarget:self action:@selector(stepButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [headerButtonsView addSubview:bt];
            [arrButtons addObject:bt];
        }
    }
}

//////////////////////////////////////////////////////////////////////     _//////////_     [ UI || UX         << >> ]    _//////////_
#pragma mark -  Util, Button touched
- (void)setButtonView:(NSInteger)index {
    [self logCallerMethodwith:@"  " newLine:1];

    for (int k = 0; k < arrButtons.count; k++) {
        [arrButtons[k] setBackgroundImage:[UIImage imageNamed:@"menu_step_gray_btn"] forState:UIControlStateNormal];
    }
    UIButton *btn = (UIButton*)[self.view viewWithTag:index];
    [btn setBackgroundImage:[UIImage imageNamed:@"menu_step_red_btn"] forState:UIControlStateNormal];
}

- (void)stepButtonTouched:(id)sender {
    //[self logCallerMethodwith:@"  button Touched   !!!!  " newLine:20];
    [log logUiAction:@"  StepbyStep VC  ::  stepButtonTouched   " lnum:5 printOn:true];

    //if (signalVw != nil) signalVw.hidden = true;

    [_progForce setProgress:0.f];
    [_imgVwMiddleMessage setHidden:false]; // 가운데 이미지 켜기.
    [dObj.operationTimer resetTime];
    [dObj.operationTimer forcePause];
    UIButton *bt = (UIButton*)sender;

    // tag : safety, resp, airway, checkBreath, emergency, comp, resp, aed   21 ...  check pulse > 30
    //NSInteger tagArray[8] = { 21, 22, 23, 24, 25, 26, 27, 28 };
    switch (bt.tag) {
        case 21: // Safety
            bleMan.bleState = S_STEPBYSTEP_SAFETY;            [self setSafety];
            break;
        case 22: // response
            bleMan.bleState = S_STEPBYSTEP_RESPONSE;          [self setResponse];
            break;
        case 23: // airway
            bleMan.bleState = S_STEPBYSTEP_AIRWAY;            [self setAirWay];
            break;
        case 24: // checkbreath
            bleMan.bleState = S_STEPBYSTEP_CHECK_BRTH;        [self setCheckBreath];
            break;
        case 25: // emergency
            bleMan.bleState = S_STEPBYSTEP_EMERGENCY;         [self setEmergency];
            break;
        case 26: // comp
            bleMan.bleState = S_STEPBYSTEP_COMPRESSION;       [self startCompression]; return;
        case 27: // breath
            bleMan.bleState = S_STEPBYSTEP_BREATH;            [self startBreathProcess]; return;
        case 28: // aed
            bleMan.bleState = S_STEPBYSTEP_AED;               [self setAED];
            break;
        case 30: // check pulse
            bleMan.bleState = S_STEPBYSTEP_CHECKPULSE;        [self setCheckPulse];
            break;
    }
    [bleMan operationStop];
    [log logThis:@"   stepButtonTouched   Ended   ============================================================   stepButtonTouched   Ended" lnum:3];
}

- (void)setManikinImage { // 타이머에서 계속 불림..
    if ([self isAllInOne]) {
        //NSLog(@" All in one  마네킨 이미지 세팅..  isManikinLeft : %d  ", isManikinLeft);
        // state 는 0에서 시작..
        NSString* lR = isManikinLeft? @"left": @"right";
        NSString* imgName = [NSString stringWithFormat: @"bg_school_step%d_%@", ((int)bleMan.calcManager.health + 1), lR];
        [_backgroundImageView setImage:[UIImage imageNamed:imgName]];
    } else {
        //NSLog(@" 단계별.  마네킨 이미지 세팅..  isManikinLeft : %d  ", isManikinLeft);
        if (isManikinLeft)  [_backgroundImageView setImage:[UIImage imageNamed:@"bg_road_left"]]; //@"bg_road_left"]]; // 마네킹 방향.
        else                [_backgroundImageView setImage:[UIImage imageNamed:@"bg_road_right"]];
    }
}

- (BOOL)isAllInOne {
    return bleMan.parsingState == AllInOne10;
}





@end




// .....
//        [_descriptionLabel setAttributedText:
//         [HSAttributedString defaultStyleAttributedString:lObj.compression_info_txt
//                                                     font:fontContent
//                                                fontColor:COLOR_HS_BLACK]];

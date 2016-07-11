//
//  StepByStepTrialViewController.h
//  heartisense
//
//  Created by jeongyuchan on 2015. 5. 1..
//  Copyright (c) 2015년 gyuchan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "HSPeripheral.h"
#import "HSBaseService.h"

#import "HSEnumSet.h"
#import "HSDataStaticValues.h"

#import "M13ProgressViewSegmentedBar.h"
#import "M13ProgressViewBar.h"
//#import "MZTimerLabel.h"

#import "HsBleManager.h"

@class MuState, HtNullableBool, HtImageView, TrainerSignalView;

@interface StepByStepTrialViewController : UIViewController
{
 
    MuState *curStepWatch;
    HtNullableBool *skipLastAED;
    TrainerSignalView *signalVw;
}

- (void)AllInOneInitProcess;
- (void)setHeaderButtons;
- (void)uiUpdateAction;

- (void)startCompression;
- (void)startBreathProcess;

- (void)setSafety;
- (void)setAirWay;
- (void)setCheckBreath;

- (void)setAED;
- (void)setEmergency;
- (void)setResponse;
- (void)setCheckPulse;
- (void)startWholeInOneProcessWithCompression;

- (void)turnOffSignals;

//@property (strong, nonatomic) MuState *curStepWatch;

//@property (nonatomic, assign) HSSelectMode selectMode;
//@property (nonatomic, assign) HSUserMode userMode;

@property (strong, nonatomic) HtNullableBool *skipLastAED;
@property (strong, nonatomic) TrainerSignalView *signalVw;

- (void)bypassModeChangedAction;

@property (weak, nonatomic) IBOutlet UILabel *labelCompYelow;
@property (weak, nonatomic) IBOutlet UILabel *labelCompGren;
@property (weak, nonatomic) IBOutlet UILabel *labelCompRed;

@property (weak, nonatomic) IBOutlet UIView *viewGraphMarkComp;
@property (weak, nonatomic) IBOutlet UIView *viewGraphMarkBrth;
@property (weak, nonatomic) IBOutlet UIProgressView *progForce;


@property (weak, nonatomic) IBOutlet M13ProgressViewSegmentedBar *progressCount;
@property (weak, nonatomic) IBOutlet M13ProgressViewBar *countProgressView;

//@property (weak, nonatomic) IBOutlet MZTimerLabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelCompBreath;
@property (weak, nonatomic) IBOutlet UILabel *labelTryNum;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlVwExplain;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;

@property (weak, nonatomic) IBOutlet UIButton *bttnRetrySkip;
@property (weak, nonatomic) IBOutlet UIButton *bttnPause;
@property (weak, nonatomic) IBOutlet UIButton *bttnGoHome;
@property (weak, nonatomic) IBOutlet UILabel *labelExplain;

@property (weak, nonatomic) IBOutlet UILabel *labelSpeed; //  스피드 관련 추가된 라벨, 이미지.
@property (weak, nonatomic) IBOutlet UIImageView *imgSpdSlow;
@property (weak, nonatomic) IBOutlet UIImageView *imgSpdGood;
@property (weak, nonatomic) IBOutlet UIImageView *imgSpdFast;
@property (weak, nonatomic) IBOutlet UILabel *labelSpdSlow;
@property (weak, nonatomic) IBOutlet UILabel *labelSpdGood;
@property (weak, nonatomic) IBOutlet UILabel *labelSpdFast;
@property (weak, nonatomic) IBOutlet UILabel *labelSpeedBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgSlowFastSign;


@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UIView *imgVwMiddleMessage;

//@property (weak, nonatomic) IBOutlet UIImageView *imgMsgGood;  // Good, Weak, Wrong Position..
//@property (weak, nonatomic) IBOutlet UIImageView *imgMsgWeak;
//@property (weak, nonatomic) IBOutlet UIImageView *imgVwMsgUp;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwMsgDn;  // wrong position

//@property (weak, nonatomic) IBOutlet HtImageView *infoImageView;

@property (weak, nonatomic) IBOutlet HtImageView *imgVwInfo;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblCycle;

@property (weak, nonatomic) IBOutlet UILabel *lblSignalMsg;


@property (weak, nonatomic) IBOutlet UIView *viewCompImgs;

@property (weak, nonatomic) IBOutlet UIImageView *imgArrow1;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow2;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow3;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow4;

@property (weak, nonatomic) IBOutlet UIImageView *imgCenterCircle;

@property (weak, nonatomic) IBOutlet UIView *viewWholeInOne;  // 올인원 상태 표시 신호등..
@property (weak, nonatomic) IBOutlet UIView *viewWholeInOne4Rescure;



@end

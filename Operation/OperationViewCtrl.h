//
//  OperationViewCtrl.h
//  heartisense
//
//  Created by Jongwoo Moon on 2015. 10. 14..
//  Copyright © 2015년 gyuchan. All rights reserved.
//

#ifndef OperationViewCtrl_h
#define OperationViewCtrl_h


#endif /* OperationViewCtrl_h */

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "StepByStepTrialViewController.h"

@interface OperationViewCtrl : StepByStepTrialViewController <BleManToVCtrlProtocol>

@property (weak, nonatomic) IBOutlet UIView *viewEntireSignalRescure;
@property (weak, nonatomic) IBOutlet UIView *viewEntireDoctor;



@end
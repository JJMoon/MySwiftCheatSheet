//
//  FirstViewController.m
//  ObjSwiftBed
//
//  Created by JJTTMOON on 2017. 7. 19..
//  Copyright © 2017년 JJTTMOON. All rights reserved.
//

#import "FirstViewController.h"
#import <LGAlertView.h>

@interface FirstViewController ()

@end


// Master.. branch..
// Develop ..  experiment flow..
//   add 2nd .. flow
//   add 3rd ..
// Merged..

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actShowPopup:(id)sender {
    NSLog(@"\n\n  Show Popup Button Touched !!! \n\n");
    LGAlertView *alrtVw = [[LGAlertView alloc] initWithTitle:@"Title"
                                                     message:@"Message"
                                                       style:LGAlertViewStyleAlert
                                                buttonTitles:NULL
                                           cancelButtonTitle:@"OK"
                                      destructiveButtonTitle:NULL];
    [alrtVw show];
}


@end

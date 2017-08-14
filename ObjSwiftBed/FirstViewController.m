//
//  FirstViewController.m
//  ObjSwiftBed
//
//  Created by JJTTMOON on 2017. 7. 19..
//  Copyright © 2017년 JJTTMOON. All rights reserved.
//

#import "FirstViewController.h"
#import <LGAlertView.h>

#import "ObjSwiftBed-Swift.h"

@interface FirstViewController ()


@end


// Master.. branch.. Again ...   For test  ""  Hot fix  """
//   hotfix 001
//   hotfix 002
// hotfix second and again..
//
// Feature experiment.. 2 ..

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

- (IBAction)actTestA:(UIButton *)sender {
    //NSArray *arr = [[NSArray alloc] initWithObjects:@"1",@"0",@"0",nil];
    Experi * exp = [[Experi alloc] init];
    [exp arrayTest];
}


@end

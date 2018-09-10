//
//  MdlArray.m
//  ObjSwiftBed
//
//  Created by Jongwoo Moon on 2018. 9. 10..
//  Copyright © 2018년 JJTTMOON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MdlArray.h"


//////////////////////////////////////////////////////////////////////////////////////////
# pragma mark - Model Array Implementation   Private methods

@interface MdlArray () {
  @private  ;
  NSMutableArray *arrMutable;
}

@end

//////////////////////////////////////////////////////////////////////////////////////////
@implementation MdlArray
//////////////////////////////////////////////////////////////////////////////////////////

// @synthesize mgoBG, mgoDeco;

//////////////////////////////////////////////////////////////////////         [ HtShape ]
#pragma mark - 생성자, 소멸자.
-(id)init {
  NSLog(@" Model Array :: init ");
  self = [super init];
  
  [self testCode];
  return self;
}

-(void)dealloc {
}

-(void)testCode {
  arrMutable = [[NSMutableArray alloc] init];
  [arrMutable addObject:@"item one"];
  [arrMutable addObject:@"item two"];
  
  NSLog(@"  the array : %@", arrMutable);
  
}

//
//-(void)initialHtShape // *** PRIVATE ***
//{
//  mgoBG = nil; // 생성은 drawHeart, .. 에서.
//  mgoDeco = nil;
//  mgoWidth = mgoHeight = [self getAround:50 anySign:NO];
//  mblRandom = NO; // 기본은 랜덤 없이. ...
//}

@end

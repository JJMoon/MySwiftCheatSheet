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

@interface SomeObj : NSObject {
//  NSString *name;
//  NSString *other;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *other;
@end

@implementation SomeObj
-(id)init {
  self = [super init];
  return self;
}
@end


@interface MdlArray () {
  @private  ;
  NSMutableArray *arrMutable;
}



@end

//////////////////////////////////////////////////////////////////////////////////////////
@implementation MdlArray
//////////////////////////////////////////////////////////////////////////////////////////


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
  
  SomeObj* aObj = [[SomeObj alloc] init];
  aObj.name = @"a";
  aObj.other = @"a init";
  [arrMutable addObject:aObj];
  aObj = [[SomeObj alloc] init];
  aObj.name = @"b";
  aObj.other = @"b init";
  [arrMutable addObject:aObj];
  aObj = [[SomeObj alloc] init];
  aObj.name = @"c";
  aObj.other = @"c init";
  [arrMutable addObject:aObj];
  NSLog(@"  the array : %@", arrMutable);
  
  aObj = [[SomeObj alloc] init];
  aObj.name = @"f";
  aObj.other = @"f new one";
  [self filterAdd:aObj];
  
  aObj = [[SomeObj alloc] init];
  aObj.name = @"b";
  aObj.other = @"b new one  edited";
  [self filterAdd:aObj];
}

# pragma mark - Filtering for preventing duplication. Remove duplication and fill with new one
-(void)filterAdd:(SomeObj*)aObj {
  NSLog(@"\n  Add new object : %@", aObj.name);
  int delTar = -1;
  for (int k = 0; k < arrMutable.count; k++) {
    SomeObj *cur = arrMutable[k];
    if (cur.name == aObj.name) {
      delTar = k;
    }
  }
  if (delTar > 0) {
    [arrMutable removeObjectAtIndex:delTar];
  }
  [arrMutable addObject:aObj];
  [self showTheArray];
}

-(void)showTheArray {
  for (int k=0; k < arrMutable.count; k++) {
    SomeObj *cur = (SomeObj*)arrMutable[k];
    NSLog(@"  cur :: %@  %@", cur.name, cur.other);
  }
}

@end

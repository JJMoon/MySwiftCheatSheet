//
//  MdlArray.h
//  ObjSwiftBed
//
//  Created by Jongwoo Moon on 2018. 9. 10..
//  Copyright © 2018년 JJTTMOON. All rights reserved.
//


//  mht : hansoo term   mui : UI            mst : state         mtm : Thread/tiMer
//  mit : integer       mfo : float         mbl : bool          mgo : geometry
//  arr : array         dic : dictionary    mla : Layer         man : ANima
//  mdd : distance      mpo : point         mcl : color         mpa : path
//  mgn : generateObj   mtp : tempObj       moj : object        mng : manageObj
//

#ifndef MdlArray_h
#define MdlArray_h


@interface MdlArray : NSObject
{
  // int mitKind; // 0:Heart 1:Diamond 2:Spade 3:Clover
  
  NSMutableArray *arrTotal;
  // UIViewController* vw;
}
//////////////////////////////////////////////////////////////////////////////////////////
# pragma mark - property  #### Don't forget to ADD synthesize ####

// @property (nonatomic, retain) UIViewController* vw;


// initialize & dealloc related.
-(id)init;

//-(CGPoint)randomPosition:(CGPoint)pTarget;
//
//-(void)putAt:(CGPoint)pPosition nSuperLa:(CAShapeLayer *)pSuper;
//
//// draw Shapes
//-(void)drawHeart;
//

@end

#endif /* MdlArray_h */

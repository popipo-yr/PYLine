//
//  UIView.m
//  test
//
//  Created by yr on 16/5/10.
//  Copyright © 2016年 yr. All rights reserved.
//

#import "UIView_Line+Addition.h"

@implementation UIView (LineSimple)

- (PYLineInfo *)normalFullLineInfo
{
    PYLineInfo *aLineInfo = [[PYLineInfo alloc] init];
    aLineInfo.width = _C_Full_Line_Width;
    aLineInfo.color = _C_Full_Line_Color;

    return aLineInfo;
}


- (PYLineInfo *)normalDottedLineInfo
{
    PYLineInfo *aLineInfo = [[PYLineInfo alloc] init];
    aLineInfo.width = _C_Dotted_Line_Width;
    aLineInfo.color = _C_Dotted_Line_Color;

    [aLineInfo configDottedLineWithDottleInterval:_C_Dotted_Line_DottedLength
                                     realInterval:_C_Dotted_Line_FullLength];

    return aLineInfo;
}


//实线
- (void)addFullLineAtTop
{
    [self addFullLineAtTopWithStartBlank:0 endBlank:0];
}


- (void)addFullLineAtLeft
{
    [self addFullLineAtLeftWithStartBlank:0 endBlank:0];
}


- (void)addFullLineAtBottom
{
    [self addFullLineAtBottomWithStartBlank:0 endBlank:0];
}


- (void)addFullLineAtRight
{
    [self addFullLineAtRightWithStartBlank:0 endBlank:0];
}


- (void)addFullLineAtTopWithStartBlank:(CGFloat)sBlank
                              endBlank:(CGFloat)eBlank
{
    PYLineInfo *aLineInfo = [self normalFullLineInfo];

    [aLineInfo configSpecailLineWithStartPoint:PYLinePointLeftUP
                                      endPoint:PYLinePointRightUp
                          startBlankPercentage:sBlank
                            endBlankPercentage:eBlank];

    [self addLineInfo:aLineInfo clearOld:false];
}


- (void)addFullLineAtLeftWithStartBlank:(CGFloat)sBlank
                               endBlank:(CGFloat)eBlank
{
    PYLineInfo *aLineInfo = [self normalFullLineInfo];
    [aLineInfo configSpecailLineWithStartPoint:PYLinePointLeftUP
                                      endPoint:PYLinePointLeftDown
                          startBlankPercentage:sBlank
                            endBlankPercentage:eBlank];

    [self addLineInfo:aLineInfo clearOld:false];
}


- (void)addFullLineAtBottomWithStartBlank:(CGFloat)sBlank
                                 endBlank:(CGFloat)eBlank
{
    PYLineInfo *aLineInfo = [self normalFullLineInfo];
    [aLineInfo configSpecailLineWithStartPoint:PYLinePointLeftDown
                                      endPoint:PYLinePointRightDown
                          startBlankPercentage:sBlank
                            endBlankPercentage:eBlank];

    [self addLineInfo:aLineInfo clearOld:false];
}


- (void)addFullLineAtRightWithStartBlank:(CGFloat)sBlank
                                endBlank:(CGFloat)eBlank
{
    PYLineInfo *aLineInfo = [self normalFullLineInfo];
    [aLineInfo configSpecailLineWithStartPoint:PYLinePointRightUp
                                      endPoint:PYLinePointRightDown
                          startBlankPercentage:sBlank
                            endBlankPercentage:eBlank];

    [self addLineInfo:aLineInfo clearOld:false];
}


//虚线

- (void)addDottedLineAtTop
{
    [self addDottedLineAtTopWithStartBlank:0 endBlank:0];
}


- (void)addDottedLineAtLeft
{
    [self addDottedLineAtLeftWithStartBlank:0 endBlank:0];
}


- (void)addDottedLineAtBottom
{
    [self addDottedLineAtBottomWithStartBlank:0 endBlank:0];
}


- (void)addDottedLineAtRight
{
    [self addDottedLineAtRightWithStartBlank:0 endBlank:0];
}


- (void)addDottedLineAtTopWithStartBlank:(CGFloat)sBlank
                                endBlank:(CGFloat)eBlank
{
    PYLineInfo *aLineInfo = [self normalDottedLineInfo];

    [aLineInfo configSpecailLineWithStartPoint:PYLinePointLeftUP
                                      endPoint:PYLinePointRightUp
                          startBlankPercentage:sBlank
                            endBlankPercentage:eBlank];

    [self addLineInfo:aLineInfo clearOld:false];
}


- (void)addDottedLineAtLeftWithStartBlank:(CGFloat)sBlank
                                 endBlank:(CGFloat)eBlank
{
    PYLineInfo *aLineInfo = [self normalDottedLineInfo];
    [aLineInfo configSpecailLineWithStartPoint:PYLinePointLeftUP
                                      endPoint:PYLinePointLeftDown
                          startBlankPercentage:sBlank
                            endBlankPercentage:eBlank];

    [self addLineInfo:aLineInfo clearOld:false];
}


- (void)addDottedLineAtBottomWithStartBlank:(CGFloat)sBlank
                                   endBlank:(CGFloat)eBlank
{
    PYLineInfo *aLineInfo = [self normalDottedLineInfo];
    [aLineInfo configSpecailLineWithStartPoint:PYLinePointLeftDown
                                      endPoint:PYLinePointRightDown
                          startBlankPercentage:sBlank
                            endBlankPercentage:eBlank];

    [self addLineInfo:aLineInfo clearOld:false];
}


- (void)addDottedLineAtRightWithStartBlank:(CGFloat)sBlank
                                  endBlank:(CGFloat)eBlank
{
    PYLineInfo *aLineInfo = [self normalDottedLineInfo];
    [aLineInfo configSpecailLineWithStartPoint:PYLinePointRightUp
                                      endPoint:PYLinePointRightDown
                          startBlankPercentage:sBlank
                            endBlankPercentage:eBlank];

    [self addLineInfo:aLineInfo clearOld:false];
}


@end
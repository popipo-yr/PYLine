//
//  UIView.h
//  test
//
//  Created by yr on 16/5/10.
//  Copyright © 2016年 yr. All rights reserved.
//

#import "UIView_Line.h"



///实现配置信息
#define _C_Full_Line_Width  10.0f
#define _C_Full_Line_Color [UIColor blackColor]

///虚线配置信息
#define _C_Dotted_Line_Width 6.0f
#define _C_Dotted_Line_Color [UIColor blackColor]
#define _C_Dotted_Line_DottedLength  2.0f
#define _C_Dotted_Line_FullLength   2.0f


/////画线简单封装
@interface UIView (LineSimple)

///sBlank
///线条开始位置空白长度与两顶点长度的百分比
///eBlank
///线条结束位置空白长度与两顶点长度的百分比

///top:     左上 -> 右上
///left:    左上 -> 左下
///bottom:  左下 -> 右下
///right:   右上 -> 右下

//实线
- (void)addFullLineAtTop;
- (void)addFullLineAtLeft;
- (void)addFullLineAtBottom;
- (void)addFullLineAtRight;

- (void)addFullLineAtTopWithStartBlank:(CGFloat)sBlank
                              endBlank:(CGFloat)eBlank;
- (void)addFullLineAtLeftWithStartBlank:(CGFloat)sBlank
                               endBlank:(CGFloat)eBlank;
- (void)addFullLineAtBottomWithStartBlank:(CGFloat)sBlank
                                 endBlank:(CGFloat)eBlank;
- (void)addFullLineAtRightWithStartBlank:(CGFloat)sBlank
                                endBlank:(CGFloat)eBlank;

//虚线
- (void)addDottedLineAtTop;
- (void)addDottedLineAtLeft;
- (void)addDottedLineAtBottom;
- (void)addDottedLineAtRight;

- (void)addDottedLineAtTopWithStartBlank:(CGFloat)sBlank
                                endBlank:(CGFloat)eBlank;
- (void)addDottedLineAtLeftWithStartBlank:(CGFloat)sBlank
                                 endBlank:(CGFloat)eBlank;
- (void)addDottedLineAtBottomWithStartBlank:(CGFloat)sBlank
                                   endBlank:(CGFloat)eBlank;
- (void)addDottedLineAtRightWithStartBlank:(CGFloat)sBlank
                                  endBlank:(CGFloat)eBlank;


@end
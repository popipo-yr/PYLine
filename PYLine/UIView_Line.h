//
//  UIView.h
//
//
//  Created by yr on 15/9/4.
//  Copyright (c) 2015年 yr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PYLineInfo;

/***************************************/
/*画线*/
/***************************************/
@interface UIView (Line_Draw)

/*设置true时,画线动作将不会执行*/
@property (nonatomic, assign)  BOOL drawLineDisable;

/*添加线条*/
- (void)addLineInfo:(PYLineInfo *)lineInfo; //默认不会清空以前的线条
- (void)addLineInfo:(PYLineInfo *)lineInfo clearOld:(BOOL)clear;
/*清空线条信息*/
- (void)clearLineInfo;

@end



/******************************/
/*线条参数*/
/*关于特殊的线条,由一个矩形的四个顶点创建的线段*/
/***************************************/
@interface PYLineInfo : NSObject

    typedef  NS_ENUM (NSInteger, PYLinePoint){
    PYLinePointLeftUP    = 0,   //左上角
    PYLinePointLeftDown  = 1,   //左下角
    PYLinePointRightDown = 2,   //右下角
    PYLinePointRightUp   = 3,   //右上角
};


@property(nonatomic, assign) CGFloat width; ///线条宽度
@property(nonatomic, strong) UIColor *color; ///线条颜色
@property(nonatomic, assign) CGPoint startPoint;  ///起始点
@property(nonatomic, assign) CGPoint endPoint;    ///结束点

/*虚线定义, 所有属性不能直接修改*/
@property(nonatomic, readonly) BOOL    isDottedLine;
@property(nonatomic, readonly) CGFloat dottedLineLength; ///虚线时线段间隔的长度;实线时为0
@property(nonatomic, readonly) CGFloat fullLineLength;   ///虚线时线段的长度;实线时为大于0任何值,最优值为线段长度


/*specail定义, 所有属性不能直接修改*/
@property(nonatomic, readonly) BOOL        isSpecail; //是否时特殊线条
@property(nonatomic, readonly) PYLinePoint startPointSpecial;  ///开始的顶点
@property(nonatomic, readonly) PYLinePoint endPointSpecial;    ///结束的顶点
///线条空白长度与两顶点长度的百分比,正数空白在开始点,负数空白在结束点
@property(nonatomic, readonly) CGFloat     startBlankPercentage;
@property(nonatomic, readonly) CGFloat     endblankPercentage;


////配置虚线信息
- (void)configDottedLineWithDottleInterval:(CGFloat)dottleInterval
                              realInterval:(CGFloat)realInterval;


////配置特殊实线信息
- (void)configSpecailLineWithStartPoint:(PYLinePoint)startPoint
                               endPoint:(PYLinePoint)endPoint
                   startBlankPercentage:(CGFloat)startBlankPercentage
                     endBlankPercentage:(CGFloat)endBlankPercentage;


////转换特色线条的顶点到普通坐标系的点,bounds为转化参照的大小
- (void)coverSpecailPointToNormalInBounds:(CGRect)bounds;

@end
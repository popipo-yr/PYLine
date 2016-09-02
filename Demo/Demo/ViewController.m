//
//  ViewController.m
//  PYLine
//
//  Created by yr on 16/6/7.
//  Copyright © 2016年 yr. All rights reserved.
//

#import "ViewController.h"
#import "UIView_Line+Addition.h"

#define _C_Sample_Width 120.0f
#define _C_Sample_Height 120.0f
#define _C_Sample_Interval_Top 30.0f
#define _C_Sample_Interval_Right 30.0f



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
}


- (void)setupViews
{
    UIView *context = self.view;

    ////快捷方式
    UIView *sample_Full = [self sampleViewWithTittle:@"Full Line"];
    [sample_Full addFullLineAtTop];
    [sample_Full addFullLineAtRight];
    [sample_Full addFullLineAtLeft];
    [sample_Full addFullLineAtBottom];
    [self configView:sample_Full xIndex:0 yIndex:0];
    [context addSubview:sample_Full];

    UIView *sample_Full_Blank = [self sampleViewWithTittle:@"Full Blank"];
    [sample_Full_Blank addFullLineAtTopWithStartBlank:0.2 endBlank:0.2];
    [sample_Full_Blank addFullLineAtRightWithStartBlank:0.2 endBlank:0.2];
    [sample_Full_Blank addFullLineAtLeftWithStartBlank:0.2 endBlank:0.2];
    [sample_Full_Blank addFullLineAtBottomWithStartBlank:0.2 endBlank:0.2];
    [self configView:sample_Full_Blank xIndex:1 yIndex:0];
    [context addSubview:sample_Full_Blank];

    UIView *sample_Dotted = [self sampleViewWithTittle:@"Dotted Line"];
    [sample_Dotted addDottedLineAtTop];
    [sample_Dotted addDottedLineAtRight];
    [sample_Dotted addDottedLineAtLeft];
    [sample_Dotted addDottedLineAtBottom];
    [self configView:sample_Dotted xIndex:0 yIndex:1];
    [context addSubview:sample_Dotted];

    UIView *sample_Dotted_Blank = [self sampleViewWithTittle:@"Dotted Blank"];
    [sample_Dotted_Blank addDottedLineAtTopWithStartBlank:0.2 endBlank:0.2];
    [sample_Dotted_Blank addDottedLineAtRightWithStartBlank:0.2 endBlank:0.2];
    [sample_Dotted_Blank addDottedLineAtLeftWithStartBlank:0.2 endBlank:0.2];
    [sample_Dotted_Blank addDottedLineAtBottomWithStartBlank:0.2 endBlank:0.2];
    [self configView:sample_Dotted_Blank xIndex:1 yIndex:1];
    [context addSubview:sample_Dotted_Blank];

    /////自定义
    UIView *sample_Cross_Full = [self sampleViewWithTittle:@"Full Cross"];

    PYLineInfo *crossFull_LT_RB = [[PYLineInfo alloc] init];
    crossFull_LT_RB.width = _C_Full_Line_Width;
    crossFull_LT_RB.color = _C_Full_Line_Color;

    [crossFull_LT_RB configSpecailLineWithStartPoint:PYLinePointLeftUP
                                            endPoint:PYLinePointRightDown
                                startBlankPercentage:0.1f
                                  endBlankPercentage:0.1f];

    PYLineInfo *crossFull_LB_RU = [[PYLineInfo alloc] init];
    crossFull_LB_RU.width = _C_Full_Line_Width;
    crossFull_LB_RU.color = _C_Full_Line_Color;
    [crossFull_LB_RU configSpecailLineWithStartPoint:PYLinePointLeftDown
                                            endPoint:PYLinePointRightUp
                                startBlankPercentage:0.1f
                                  endBlankPercentage:0.1f];

    [sample_Cross_Full addLineInfo:crossFull_LT_RB clearOld:false];
    [sample_Cross_Full addLineInfo:crossFull_LB_RU clearOld:false];
    [self configView:sample_Cross_Full xIndex:0 yIndex:2];
    [context addSubview:sample_Cross_Full];

    UIView *sample_Cross_Dotted = [self sampleViewWithTittle:@"Dotted Cross"];

    PYLineInfo *crossDotted_LT_RB = [[PYLineInfo alloc] init];
    crossDotted_LT_RB.width = _C_Dotted_Line_Width;
    crossDotted_LT_RB.color = [UIColor redColor];

    [crossDotted_LT_RB configDottedLineWithDottleInterval:3.0f realInterval:3.0f];
    [crossDotted_LT_RB configSpecailLineWithStartPoint:PYLinePointLeftUP
                                              endPoint:PYLinePointRightDown
                                  startBlankPercentage:0.2f
                                    endBlankPercentage:0.2f];

    PYLineInfo *crossDotted_LB_RU = [[PYLineInfo alloc] init];
    crossDotted_LB_RU.width = _C_Dotted_Line_Width;
    crossDotted_LB_RU.color = [UIColor redColor];
    [crossDotted_LT_RB configDottedLineWithDottleInterval:3.0f realInterval:3.0f];
    [crossDotted_LB_RU configSpecailLineWithStartPoint:PYLinePointLeftDown
                                              endPoint:PYLinePointRightUp
                                  startBlankPercentage:0.2f
                                    endBlankPercentage:0.2f];

    [sample_Cross_Dotted addLineInfo:crossDotted_LT_RB clearOld:false];
    [sample_Cross_Dotted addLineInfo:crossDotted_LB_RU clearOld:false];
    [self configView:sample_Cross_Dotted xIndex:1 yIndex:2];
    [context addSubview:sample_Cross_Dotted];
}


- (UIView *)sampleViewWithTittle:(NSString *)title
{
    UIView *sampleView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  _C_Sample_Width,
                                                                  _C_Sample_Height)];

    UILabel *lable = [[UILabel alloc] initWithFrame:sampleView.bounds];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text          = title;
    [sampleView addSubview:lable];

    sampleView.backgroundColor = [UIColor grayColor];

    return sampleView;
};


- (void)configView:(UIView *)view xIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex
{
    CGPoint origin = CGPointZero;
    origin.x = (_C_Sample_Interval_Right + _C_Sample_Width)*xIndex + _C_Sample_Interval_Right;
    origin.y = (_C_Sample_Interval_Top + _C_Sample_Height)*yIndex + _C_Sample_Interval_Top;

    [self setView:view origin:origin];
}


- (void)setView:(UIView *)view origin:(CGPoint)origin
{
    CGRect frame = view.frame;
    frame.origin = origin;
    view.frame   = frame;
}


@end

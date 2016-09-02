//
//  UIView.m
//
//
//  Created by yr on 15/9/4.
//  Copyright (c) 2015年 yr. All rights reserved.
//

#import "UIView_Line.h"
#import <objc/runtime.h>

@class DrawDelegate;

/////////////////////////////////
@interface UIView (Line_Param)

@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) DrawDelegate   *drawDelegate;
@property (nonatomic, strong) CALayer        *drawLayer;

@end


/////////////////////////////////
#pragma mark - #DrawDelegate

@interface DrawDelegate : NSObject {
    __weak UIView *_holdView;
}

- (instancetype)initWithHoldView:(UIView *)view;

@end

@implementation DrawDelegate

- (instancetype)initWithHoldView:(UIView *)view
{
    if (self = [super init]) {
        _holdView = view;
    }

    return self;
}


/**
 * 当点击UITextfield进入输入状态的时crash
 *
 * 原因:输入的时候有个改变字体的动画,视图调用layer的delegate的这个方法时,没有进行判断
 *     UIKit`-[CALayer(TextEffectsLayerOrdering) compareTextEffectsOrdering:]:
 *
 * 处理方式:第一种,添加方法compareTextEffectsOrdering:,
 *        第二种,发现这个视图是window的子类,禁止window子类添加drawlayer
 */
- (void)compareTextEffectsOrdering:(id)some
{
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if (_holdView.drawLineDisable) return;

    for (PYLineInfo *aLineInfo in  _holdView.lines) {
        CGContextRef context = ctx;
        CGContextBeginPath(context);
        CGContextSetShouldAntialias(context, NO);
        if (aLineInfo.isDottedLine) {
            CGFloat lengths[] = {aLineInfo.dottedLineLength, aLineInfo.fullLineLength};
            CGContextSetLineDash(context, 0, lengths, 2);
        }

        if (aLineInfo.isSpecail) {
            [aLineInfo coverSpecailPointToNormalInBounds:_holdView.bounds];
        }

        CGPoint startPoint = aLineInfo.startPoint;
        CGPoint endPoint   = aLineInfo.endPoint;

        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextSetLineWidth(context, aLineInfo.width * layer.contentsScale);
        CGContextSetStrokeColorWithColor(context, aLineInfo.color.CGColor);
        CGContextStrokePath(context);
        CGContextSetShouldAntialias(context, NO);
    }
}


/**
 * 调整drawlayer的大小为最新视图的大小
 */
- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    layer.frame = _holdView.bounds;
}


@end


/////////////////////////////////
#pragma mark - #UIView_Line_Draw


@implementation  UIView (Line_Draw)

+ (void)load
{
    Method oldInitCoder = class_getInstanceMethod([self class], @selector(initWithCoderCustom:));
    Method newInitCoder = class_getInstanceMethod([self class], @selector(initWithCoder:));
    method_exchangeImplementations(oldInitCoder, newInitCoder);

    Method oldInitFrame = class_getInstanceMethod([self class], @selector(initWithFrameCustom:));
    Method newInitFrame = class_getInstanceMethod([self class], @selector(initWithFrame:));
    method_exchangeImplementations(oldInitFrame, newInitFrame);

    Method oldSetBounds = class_getInstanceMethod([self class], @selector(setBounds:));
    Method newSetBounds = class_getInstanceMethod([self class], @selector(setBoundsCustom:));
    method_exchangeImplementations(oldSetBounds, newSetBounds);

    Method oldLayout = class_getInstanceMethod([self class], @selector(setNeedsLayout));
    Method newLayout = class_getInstanceMethod([self class], @selector(setNeedsLayoutCustom));
    method_exchangeImplementations(oldLayout, newLayout);
} /* load */


#pragma mark   Properties

/*dynamic param*/
- (NSMutableArray *)lines
{
    NSMutableArray *obj = objc_getAssociatedObject(self, @selector(lines));
    if (obj == nil) {
        obj = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, @selector(lines), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return obj;
}


- (BOOL)drawLineDisable
{
    BOOL ret = {0};
    [objc_getAssociatedObject(self, @selector(drawLineDisable)) getValue:&ret];
    return ret;
}


- (void)setDrawLineDisable:(BOOL)drawLineDisable
{
    NSValue *valueObj = [NSValue valueWithBytes:&drawLineDisable objCType:@encode(BOOL)];
    objc_setAssociatedObject(self, @selector(drawLineDisable), valueObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setDrawLayer:(CALayer *)drawLayer
{
    objc_setAssociatedObject(self, @selector(drawLayer), drawLayer,
                             OBJC_ASSOCIATION_RETAIN);
}


- (CALayer *)drawLayer
{
    return objc_getAssociatedObject(self, @selector(drawLayer));
}


- (void)setDrawDelegate:(DrawDelegate *)drawDelegate
{
    objc_setAssociatedObject(self, @selector(drawDelegate), drawDelegate,
                             OBJC_ASSOCIATION_RETAIN);
}


- (DrawDelegate *)drawDelegate
{
    return objc_getAssociatedObject(self, @selector(drawDelegate));
}


#pragma mark  Methods

- (void)_setupDrawLayer
{
    if (self.drawLayer != nil)
        return;

    /*windows的子类的calayer调用代理方法没有做判断,不附加layer*/
    if ([self isKindOfClass:[UIWindow class]])
        return;

    self.drawLayer                 = [CALayer layer];
    self.drawLayer.frame           = self.bounds;
    self.drawLayer.contentsScale   = [[UIScreen mainScreen] scale];
    self.drawLayer.backgroundColor = [UIColor clearColor].CGColor;

    [self.drawLayer setNeedsLayout];
    [self.drawLayer setNeedsDisplay]; // first need show,so whether need a switch here?
    [self.drawLayer setNeedsDisplayOnBoundsChange:true];

    [self.layer addSublayer:self.drawLayer];
} /* _setupDrawLayer */


#pragma mark  Exchange Methods
- (instancetype)initWithFrameCustom:(CGRect)frame
{
    if (self = [self initWithFrameCustom:frame]) {
        [self _setupDrawLayer];
    }

    return self;
}


- (id)initWithCoderCustom:(NSCoder *)aDecoder
{
    if (self = [self initWithCoderCustom:aDecoder]) {
        [self _setupDrawLayer];
    }

    return self;
}


/* view需要通过setNeedsLayout来重画drawlayer,
   如果view使用setNeedsDisplay,需要在drawrect处理,这样远离了出发点*/
- (void)setNeedsLayoutCustom
{
    [self setNeedsLayoutCustom];

    if (self.lines.count) {
        [self.drawLayer setNeedsDisplay];
    }
}


/*why not use setNeedsLayout layoutSubviews? let's simple*/
- (void)setBoundsCustom:(CGRect)bounds
{
    [self setBoundsCustom:bounds];

    if (self.lines.count) {
        [self.drawLayer setNeedsLayout];
    }
}


#pragma mark  Methods

- (void)_addLineReally:(PYLineInfo *)lineInfo
{
    [self.lines addObject:lineInfo];
    /*有线条的时候才设置*/
    if (self.drawDelegate == nil) {
        self.drawDelegate       = [[DrawDelegate alloc] initWithHoldView:self];
        self.drawLayer.delegate = self.drawDelegate;
    }
}


- (void)addLineInfo:(PYLineInfo *)lineInfo
{
    [self addLineInfo:lineInfo clearOld:false];
}


- (void)addLineInfo:(PYLineInfo *)lineInfo clearOld:(BOOL)clear
{
    if (clear) [self clearLineInfo];

    [self _addLineReally:lineInfo];
}


- (void)clearLineInfo
{
    [self.lines removeAllObjects];
}


@end


/////////////////////////////////
#pragma mark - #PYLineInfo

@implementation PYLineInfo {
    BOOL _isDiagonalLine; //是否为对角线,只适用于specialLine
}

-(CGFloat)width
{
    return _width * (_isDiagonalLine ? 0.5f : 1.0f); //对角线会用多个点来描线,这里进行缩小处理
}

////配置虚线信息
- (void)configDottedLineWithDottleInterval:(CGFloat)dottleInterval realInterval:(CGFloat)realInterval;
{
    _isDottedLine     = true;
    _dottedLineLength = dottleInterval;
    _fullLineLength   = realInterval;
}



- (void)configSpecailLineWithStartPoint:(PYLinePoint)startPoint
                               endPoint:(PYLinePoint)endPoint
                   startBlankPercentage:(CGFloat)startBlankPercentage
                     endBlankPercentage:(CGFloat)endBlankPercentage;
{
    _isSpecail            = true;
    _startPointSpecial    = startPoint;
    _endPointSpecial      = endPoint;
    _startBlankPercentage = startBlankPercentage;
    _endblankPercentage   = endBlankPercentage;
    _isDiagonalLine       = (abs((int)(_startPointSpecial - _endPointSpecial)) == 2);
//    _width                = _isDiagonalLine ? width / 2.0f : width;
}


- (CGPoint)_coverSpecailPoint:(PYLinePoint)specialPoint toNormalInRect:(CGRect)rect
{
    CGPoint realPoint = CGPointZero;

    switch (specialPoint) {
    case PYLinePointLeftUP:
        realPoint = CGPointMake(0, 0);
        break;

    case PYLinePointLeftDown:
        realPoint = CGPointMake(0, CGRectGetHeight(rect));
        break;

    case PYLinePointRightDown:
        realPoint = CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect));
        break;

    case PYLinePointRightUp:
        realPoint = CGPointMake(CGRectGetWidth(rect), 0);
        break;

    default:
        break;
    }

    return realPoint;
}


- (void)coverSpecailPointToNormalInBounds:(CGRect)bounds
{
    _startPoint = [self _coverSpecailPoint:_startPointSpecial toNormalInRect:bounds];
    _endPoint   = [self _coverSpecailPoint:_endPointSpecial toNormalInRect:bounds];

    CGPoint oldStartPoint = _startPoint;

    if (_startPointSpecial == _endPointSpecial) return; //为同一个点直接返回

    if (_startBlankPercentage > 0) {  //开始处包含空白
        CGFloat percentageCo = _startBlankPercentage;

        if (_isDiagonalLine || _startPoint.y == _endPoint.y) {   //对角线或者水平 需要修改start的x
            _startPoint.x = _startPoint.x != 0 ? _startPoint.x * (1 - percentageCo) : _endPoint.x * percentageCo;
        }

        if (_isDiagonalLine || _startPoint.x == _endPoint.x) {   //对角线或者垂直 需要修改start的y
            _startPoint.y = _startPoint.y != 0 ? _startPoint.y * percentageCo : _endPoint.y * (1 - percentageCo);
        }
    }

    if (_endblankPercentage > 0) { //结束处包含空白
        CGFloat percentageCo = _endblankPercentage;

        if (_isDiagonalLine || oldStartPoint.y == _endPoint.y) {   //对角线或者水平 需要修改end的x
            _endPoint.x = _endPoint.x != 0 ? _endPoint.x * (1 - percentageCo) : oldStartPoint.x *  percentageCo;
        }

        if (_isDiagonalLine || oldStartPoint.x == _endPoint.x) {   //对角线或者垂直 需要修改end的y
            _endPoint.y = _endPoint.y != 0 ? _endPoint.y * percentageCo : oldStartPoint.y * (1 - percentageCo);
        }
    }
}


@end
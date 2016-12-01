//
//  YTAssistiveTouch.m
//  YTAssistiveTouch
//
//  Created by songyutao on 2016/11/30.
//  Copyright © 2016年 Creditease. All rights reserved.
//

#import "YTAssistiveTouch.h"


NSString    *const YTAssistiveTouchClickNotification = @"YTAssistiveTouchClickNotification";

static const CGSize kYTTouchSize = {50, 50};

@interface YTAssistiveTouch ()

@property(nonatomic, strong)UIView          *touchView;
@property(nonatomic, strong)UIButton        *touchButton;
@property(nonatomic, strong)UIPanGestureRecognizer      *panGesture;

@end


@implementation YTAssistiveTouch

+ (YTAssistiveTouch *)sharedInstance
{
    static YTAssistiveTouch *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        self.windowLevel = UIWindowLevelStatusBar + 50;
        self.clipsToBounds = YES;
        
        self.touchView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kYTTouchSize.width, kYTTouchSize.height)];
        [self addSubview:self.touchView];
        
        self.touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.touchButton.backgroundColor = [UIColor redColor];
        self.touchButton.frame = CGRectMake(0, 0, kYTTouchSize.width, kYTTouchSize.height);
        [self.touchButton addTarget:self action:@selector(touchClick) forControlEvents:UIControlEventTouchUpInside];
        [self.touchView addSubview:self.touchButton];
        
        self.panGesture = [[UIPanGestureRecognizer alloc] init];
        [self.panGesture addTarget:self action:@selector(_panGestureHandle:)];
        [self.touchView addGestureRecognizer:self.panGesture];
        
        self.canDrag = YES;
        
    }
    return self;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    self.backgroundColor = [UIColor clearColor];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL allowTouch = NO;
    if (CGRectContainsPoint(self.touchView.frame, point))
    {
        allowTouch = YES;
    }
    
    if (self.rootViewController)
    {
        allowTouch = YES;
    }
    return allowTouch;
}

- (void)touchClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:YTAssistiveTouchClickNotification object:self];
}

- (void)setAssistiveImage:(UIImage *)assistiveImage
{
    _assistiveImage = assistiveImage;
    
    [self.touchButton setBackgroundImage:assistiveImage forState:UIControlStateNormal];
    [self.touchButton setBackgroundImage:assistiveImage forState:UIControlStateHighlighted];
    
    if (assistiveImage)
    {
        [self.touchButton setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [self.touchButton setBackgroundColor:[UIColor redColor]];
    }
}

- (void)setCanDrag:(BOOL)canDrag
{
    _canDrag = canDrag;
    
    self.panGesture.enabled = canDrag;
}

#pragma - mark - private
- (void)_panGestureHandle:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateChanged:
        {
            CGFloat contentViewH = self.touchView.bounds.size.height;
            CGPoint newCenter = self.touchView.center;
            newCenter.y += [panGesture translationInView:self].y;
            newCenter.x += [panGesture translationInView:self].x;
            [panGesture setTranslation:CGPointZero inView:self];
            
            if (newCenter.y > contentViewH && newCenter.y < [UIScreen mainScreen].bounds.size.height - contentViewH)
            {
                self.touchView.center = newCenter;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint center = self.touchView.center;
            
            if (self.touchView.center.x > [UIScreen mainScreen].bounds.size.width/2)
            {
                center.x = [UIScreen mainScreen].bounds.size.width-self.touchView.frame.size.width/2;
            }
            else
            {
                center.x = self.touchView.frame.size.width/2;
            }
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.touchView.center = center;
                
            } completion:nil];
        }
        default:
            break;
    }
}

- (void)shake
{
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI)];
    keyAnimaion.removedOnCompletion = YES;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.06;
    keyAnimaion.repeatCount = 15;
    [self.touchView.layer addAnimation:keyAnimaion forKey:nil];
}

- (void)show
{
    self.hidden = NO;
}

- (void)dismiss
{
    self.hidden = YES;
}

@end

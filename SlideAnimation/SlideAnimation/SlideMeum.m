//
//  SlideMeum.m
//  SlideAnimation
//
//  Created by 明镜止水 on 16/10/21.
//  Copyright © 2016年 明镜止水. All rights reserved.
//

#import "SlideMeum.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface SlideMeum ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) NSUInteger animationCount;

@property (nonatomic, assign) CGFloat diff;
@end

@implementation SlideMeum{
    
    UIVisualEffectView *blurView;
    BOOL flag;
    UIWindow *keyWindow;
    UIView *helperSlideView;
    UIView *helperSlideViewCenter;

}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        
        [self setupUI];
        
    }
    return self;
}

-(void)setupUI{
    
    keyWindow = [UIApplication sharedApplication].keyWindow;
    //毛玻璃
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    blurView = [[UIVisualEffectView alloc]initWithEffect:effect];
    blurView.frame = keyWindow.bounds ;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backSlide)];
    [blurView addGestureRecognizer:tap];
    
    //辅助视图, 用来计算diff
    helperSlideView = [[UIView alloc] initWithFrame:CGRectMake(-40, 0, 40, 40)];
    helperSlideView.backgroundColor = [UIColor redColor];
    helperSlideViewCenter = [[UIView alloc] initWithFrame:CGRectMake(-40, HEIGHT * 0.5, 40, 40)];
    helperSlideViewCenter.backgroundColor = [UIColor yellowColor];
    helperSlideView.hidden = YES;
    helperSlideViewCenter.hidden = YES;

    
    [keyWindow insertSubview:self belowSubview:helperSlideView];
    [keyWindow addSubview:helperSlideView];
    [keyWindow addSubview:helperSlideViewCenter];
}

-(void)slideAnmin{
    if (!flag) {
        
        [keyWindow insertSubview:blurView belowSubview:self];
    
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.bounds;
        }];
        //红色矩形
        [self beforeAnimation];
        
        
        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.5f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            
            helperSlideView.center = CGPointMake(WIDTH * fatorW, helperSlideView.frame.size.height * 0.5);
        } completion:^(BOOL finished) {
            
            [self finishAnimation];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            blurView.alpha = 0.09;
        }];
        
        //黄色矩形
        [self beforeAnimation];
        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            
            helperSlideViewCenter.center = CGPointMake(WIDTH * fatorW, helperSlideView.frame.size.height * 0.5);
            
        } completion:^(BOOL finished) {
            
            [self finishAnimation];
        }];
        
    }
    
    
    flag = YES;
    

}


-(void)backSlide{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(-WIDTH * fatorW - menuBlankWidth, 0, WIDTH * fatorW + menuBlankWidth, HEIGHT * fatorH);
    }];

    //红色矩形
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.5f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        helperSlideView.center = CGPointMake(-keyWindow.center.x, helperSlideView.frame.size.height * 0.5);
        
    } completion:^(BOOL finished) {
        
        [self finishAnimation];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        blurView.alpha = 0.0;
        
    }];
    
    //黄色矩形
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        helperSlideViewCenter.center = CGPointMake(-keyWindow.center.x, HEIGHT * 0.5);
        
    } completion:^(BOOL finished) {
        
        [self finishAnimation];
    }];

    flag = NO;
    
}


-(void)beforeAnimation{
    
    
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount++;
}

-(void)finishAnimation{
    
    self.animationCount--;
    if (self.animationCount == 0) {
        [self.displayLink invalidate];
        //组好设置为 nil
        self.displayLink = nil;
    }
}



-(void)displayLinkAction:(CADisplayLink *)dis{
    
    CALayer *helpSliderLayer = (CALayer *)[helperSlideView.layer presentationLayer];
    CALayer *helpSliderCenterLayer = (CALayer *)[helperSlideViewCenter.layer presentationLayer];
    
#warning 为什么不直接取出来用
    helpSliderLayer.frame.origin.x;
    helpSliderCenterLayer.frame.origin.x;
    
    CGRect helpSliderFrame = [[helpSliderLayer valueForKey:@"frame"] CGRectValue];
    CGRect helpSliderCenterFrame = [[helpSliderCenterLayer valueForKey:@"frame"] CGRectValue];
    
    _diff = helpSliderFrame.origin.x - helpSliderCenterFrame.origin.x;
    
    [self setNeedsDisplay];

}


-(void)drawRect:(CGRect)rect{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width - menuBlankWidth, 0)];
    
    CGPoint point = CGPointMake(self.frame.size.width - menuBlankWidth, self.frame.size.height);
    CGPoint controlPoint = CGPointMake(keyWindow.frame.size.width * fatorW + _diff , keyWindow.frame.size.height * 0.5);

    [path addQuadCurveToPoint:point controlPoint:controlPoint];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    
    [path closePath];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddPath(context, path.CGPath);
    
    [[UIColor greenColor] set];
    
    CGContextFillPath(context);
    
    
    
}


@end

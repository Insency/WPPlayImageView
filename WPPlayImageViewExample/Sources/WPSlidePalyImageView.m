//
//  WPSlidePalyImageView.m
//  图片轮播
//
//  Created by iyouwp on 15/4/19.
//  Copyright (c) 2015年 iyouwp. All rights reserved.
//

#import "WPSlidePalyImageView.h"

@interface WPSlidePalyImageView()


@property(nonatomic, weak) UIImageView *imgV0;
@property(nonatomic, weak) UIImageView *imgV1;
@property(nonatomic, weak) UIImageView *imgV2;


@property (weak, nonatomic) NSLayoutConstraint *image2Right;
@property (weak, nonatomic) NSLayoutConstraint *image0Left;
@property (weak, nonatomic) NSLayoutConstraint *image1Left;
@property (weak, nonatomic) NSLayoutConstraint *image1Right;


@property(nonatomic, weak)UIView *cover;
///  当前 image1 显示的图片索引
@property(nonatomic, assign)int currentI;

@property(nonatomic, strong)NSTimer *timer;
@end


@implementation WPSlidePalyImageView

#pragma mark - 手势调用方法
-(void)pan:(UIPanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.timer invalidate];
        self.timer = nil;
    }
    CGPoint point = [sender translationInView:sender.view];
    
    [self constantSlideWith:point.x];

    
    /** 手势结束需要执行的一些操作 */
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.image1Right.constant > self.width * 0.5) {
            self.currentI += 1;
        }
        if (self.image1Left.constant > self.width * 0.5) {
            self.currentI -= 1;
        }
        self.currentI = (int)((self.currentI + self.images.count) % self.images.count);

        [self slideDidPan];
        [self slideAnimatedScroll:YES];

    }
    /** 初始化 */
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)tap:(UITapGestureRecognizer *)sender{
    if (self.currentI <= self.callBacks.count && self.callBacks.count != 0) {
        touchUpInsideCallBack callBack = self.callBacks[self.currentI];
        callBack();
    }
}


#pragma mark - slide method
-(void)constantSlideWith:(CGFloat)offset{
    self.image1Left.constant += offset;
    self.image0Left.constant += offset;
    self.image1Right.constant -= offset;
    self.image2Right.constant -= offset;
    
}

-(void)slideDidPan{
    if(self.image1Right.constant < self.width * 0.5 && self.image1Left.constant < self.width * 0.5){
        [self defaultSettingConstraints];
    }else if(self.image1Right.constant >= self.width * 0.5){
        self.image1Right.constant = self.width;
        self.image1Left.constant = - self.width;
        self.image0Left.constant = - self.width * 2;
        self.image2Right.constant = 0;
    }else if(self.image1Left.constant >= self.width * 0.5){
        self.image1Right.constant = - self.width;
        self.image1Left.constant = self.width;
        self.image0Left.constant =0;
        self.image2Right.constant = - self.width * 2;
    }
}

-(void)slideAnimatedScroll:(BOOL) isPan{
    [UIView animateWithDuration:self.duration animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self fillImage];
        [self defaultSettingConstraints];
        if (isPan) {
            [self startTimer];
        }
    }];;
}

-(void)slideTimerFireMethod{
    if(self.direction == PlayImageViewDirectionRight){
        self.currentI += 1;
        [self constantSlideWith:-self.width];
    }else if (self.direction == PlayImageViewDirectionLeft){
        self.currentI -= 1;
        [self constantSlideWith:self.width];
    }
    self.currentI = (int)((self.currentI + self.images.count) % self.images.count);
    [self slideAnimatedScroll:NO];
}

-(void)dealloc{
    NSLog(@"playView 88");
}


#pragma mark - lazy and 公共方法
-(void)defaultSettingConstraints{
    self.image1Right.constant = 0;
    self.image1Left.constant = 0;
    self.image0Left.constant = -self.width;
    self.image2Right.constant = -self.width;
}


/** 开启定时器 */
-(void)startTimer
{
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(slideTimerFireMethod) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

-(void)fillImage{
    self.imgV0.image = [UIImage imageNamed:self.images[(self.currentI - 1 + self.images.count) % self.images.count]];
    self.imgV1.image = [UIImage imageNamed:self.images[self.currentI]];
    self.imgV2.image = [UIImage imageNamed:self.images[(self.currentI + 1 + self.images.count) % self.images.count]];
    self.titleLabel.text = self.titles[self.currentI];
}

-(void)willMoveToWindow:(UIWindow *)newWindow{
    self.cover.frame = self.bounds;
    self.cover.backgroundColor = [UIColor clearColor];
//    [self bringSubviewToFront:self.cover];
    [self fillImage];
    [self startTimer];
    [self defaultSettingConstraints];
}

-(void)removeFromSuperview{
    NSLog(@"removeFromSuperview");
    [self.timer invalidate];
    self.timer = nil;
    [super removeFromSuperview];
}

-(UIView *)cover{
    if (_cover == nil) {
        UIView *v = [[UIView alloc] init];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [v addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [v addGestureRecognizer:tap];
        
        [self addSubview:v];
        _cover = v;
    }
    return _cover;
}

-(UIImageView *)imgV1{
    if (_imgV1 == nil) {
        UIImageView *imgV1 = [[UIImageView alloc] init];
        [self addSubview:imgV1];
        _imgV1 = imgV1;
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:imgV1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imgV1.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:imgV1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:imgV1.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:imgV1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imgV1.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        self.image1Left = left;
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:imgV1.superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:imgV1 attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        self.image1Right = right;
        [NSLayoutConstraint activateConstraints:@[top, bottom, left, right]];
        imgV1.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imgV1;
}

-(UIImageView *)imgV0{
    if (_imgV0 == nil) {
        UIImageView *imgV0 = [[UIImageView alloc] init];
        [self addSubview:imgV0];
        _imgV0 = imgV0;
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:imgV0 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imgV0.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:imgV0 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:imgV0.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:imgV0 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imgV0.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        self.image0Left = left;
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:imgV0 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.imgV1 attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        [NSLayoutConstraint activateConstraints:@[top, bottom, left, right]];
        imgV0.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imgV0;
    
}


-(UIImageView *)imgV2{
    if (_imgV2 == nil) {
        UIImageView *imgV2 = [[UIImageView alloc] init];
        [self addSubview:imgV2];
        _imgV2 = imgV2;
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:imgV2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imgV2.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:imgV2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:imgV2.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:imgV2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imgV1 attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:imgV2.superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:imgV2 attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        self.image2Right = right;
        [NSLayoutConstraint activateConstraints:@[top, bottom, left, right]];
        imgV2.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imgV2;
    
}

@end

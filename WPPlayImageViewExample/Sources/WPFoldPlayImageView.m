//
//  WPFoldPlayImageView.m
//  图片轮播
//
//  Created by iyouwp on 15/4/19.
//  Copyright (c) 2015年 iyouwp. All rights reserved.
//

#import "WPFoldPlayImageView.h"

@interface WPFoldPlayImageView()
@property(nonatomic, weak) UIImageView *imgV0;
@property(nonatomic, weak) UIImageView *imgV1;
@property(nonatomic, weak) UIImageView *imgV2;
@property(nonatomic, weak)UIView *cover;

@property (weak, nonatomic) NSLayoutConstraint *image1Right;
@property (weak, nonatomic) NSLayoutConstraint *image1Left;


@property(nonatomic, assign)int currentI;
///  image1 相对于初始位置
@property(nonatomic, assign)BOOL left;

@property(nonatomic, strong)NSTimer *timer;

@end


@implementation WPFoldPlayImageView

#pragma mark - 手势调用方法
-(void)pan:(UIPanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.timer invalidate];
        self.timer = nil;
    }
    CGPoint point = [sender translationInView:sender.view];
    
    /** 判断 fold 类型 image1 相对于初始位置 */
    if (self.image1Right.constant == 0 && self.image1Left.constant == 0) {
        if (point.x > 0) {
            self.left = NO;
        }else{
            self.left = YES;
        }
    }
    if (self.image1Right.constant > 0 && self.image1Left.constant == 0){
        self.left = YES;
    }
    
    if (self.image1Right.constant == 0 && self.image1Left.constant > 0){
        self.left = NO;
    }
    
    [self constantFoldWith:point.x];
    
    /** 手势结束需要执行的一些操作 */
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.image1Right.constant > self.width * 0.5) {
            self.currentI += 1;
        }
        if (self.image1Left.constant > self.width * 0.5) {
            self.currentI -= 1;
        }
        self.currentI = (int)((self.currentI + self.images.count) % self.images.count);

        [self foldDidPan];
        [self foldAnimatedScroll:YES];
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
#pragma mark - fold method
-(void)constantFoldWith:(CGFloat)offset{
    if (self.left) {
        CGFloat temp = self.image1Right.constant - offset;
        self.image1Right.constant = MIN(self.width, temp);
        self.image1Right.constant = MAX(0, temp);
    }else{
        CGFloat temp = self.image1Left.constant + offset;
        self.image1Left.constant = MIN(self.width, temp);
        self.image1Left.constant = MAX(0, temp);
    }
}

-(void)foldDidPan{
    self.image1Right.constant = self.image1Right.constant < self.width * 0.5 ? 0 : self.width;
    self.image1Left.constant = self.image1Left.constant < self.width * 0.5 ? 0 : self.width;
}

-(void)foldAnimatedScroll:(BOOL) isPan{
    [UIView animateWithDuration:self.duration animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self fillImage];
        [self defaultSettingConstraints];
        if (isPan) {
            [self startTimer];
        }
    }];
    
}

-(void)foldTimeFireMethod{
    if(self.direction == PlayImageViewDirectionRight){
        self.currentI += 1;
        self.left = YES;
        [self constantFoldWith:-self.width];
    }else if (self.direction == PlayImageViewDirectionLeft){
        self.currentI -= 1;
        self.left = NO;
        [self constantFoldWith:self.width];
    }
    self.currentI = (int)((self.currentI + self.images.count) % self.images.count);
    [self foldAnimatedScroll:NO];
    
}

/** 开启定时器 */
-(void)startTimer
{
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(foldTimeFireMethod) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}


-(void)defaultSettingConstraints{
    self.image1Right.constant = 0;
    self.image1Left.constant = 0;
}


-(void)fillImage{
    self.imgV0.image = [UIImage imageNamed:self.images[(self.currentI - 1 + self.images.count) % self.images.count]];
    self.imgV1.image = [UIImage imageNamed:self.images[self.currentI]];
    self.imgV2.image = [UIImage imageNamed:self.images[(self.currentI + 1 + self.images.count) % self.images.count]];
}


-(void)willMoveToWindow:(UIWindow *)newWindow{
    self.cover.frame = self.bounds;
    self.cover.backgroundColor = [UIColor clearColor];
//    [self bringSubviewToFront:self.cover];
    [self fillImage];
    [self startTimer];
}
-(void)removeFromSuperview{
    [self.timer invalidate];
    self.timer = nil;
    [super removeFromSuperview];
}
-(void)dealloc{
    NSLog(@"playView 88");
}
#pragma mark - 子控件 lazy
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
        
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:imgV2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:imgV2.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        [NSLayoutConstraint activateConstraints:@[top, bottom, left, right]];
        imgV2.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imgV2;
    
}


@end

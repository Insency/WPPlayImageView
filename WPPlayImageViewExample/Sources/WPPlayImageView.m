//
//  WPPlayImageView.m
//  图片轮播
//
//  Created by iyouwp on 15/4/17.
//  Copyright (c) 2015年 iyouwp. All rights reserved.
//

#import "WPPlayImageView.h"
#import "WPFoldPlayImageView.h"
#import "WPSlidePalyImageView.h"
@interface WPPlayImageView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLBottom;

@property(nonatomic, strong)NSMutableArray *imagesM;
@property(nonatomic, strong)NSMutableArray *callBackM;
@property(nonatomic, strong)NSMutableArray *titleM;

@end


@implementation WPPlayImageView


+(instancetype)playImageViewType:(PlayImageViewType)type{
    WPPlayImageView *PIV;
    switch (type) {
        case PlayImageViewTypeFold:
            PIV = [[WPFoldPlayImageView alloc] init];
            break;
        case PlayImageViewTypeSlide:
            PIV = [[WPSlidePalyImageView alloc] init];
            break;
        default:
            break;
    }
    PIV.type = type;
    return PIV;
}

-(void)addImage:(NSString *)imageName touchCallBack:(void (^)())callBack{
    [self addImage:imageName title:nil touchCallBack:callBack];
}

-(void)addImage:(NSString *)imageName title:(NSString *)title touchCallBack:(void (^)())callBack{
    [self.imagesM addObject:imageName];
    /** 防止传入 nil 值 */
    if (callBack != nil) {
        [self.callBackM addObject:callBack];
    }
    if (title != nil) {
        [self.titleM addObject:title];
    }
}


-(void)setImages:(NSArray *)images{
    self.imagesM = [images mutableCopy];
}

-(NSArray *)images{
    // 是否需要使用 copy
    return [self.imagesM copy];
}

-(void)setTitles:(NSArray *)titles{
    self.titleM = [titles mutableCopy];
}

-(NSArray *)titles{
    return [self.titleM copy];
}

-(void)setCallBacks:(NSArray *)callBacks{
    self.callBackM = [callBacks mutableCopy];
}

-(NSArray *)callBacks{
    return [self.callBackM copy];
}

-(double)duration{
    if (_duration == 0) {
        _duration = 0.5;
    }
    return _duration;
}

-(double)timeInterval{
    if (_timeInterval == 0) {
        _timeInterval = 2.0;
    }
    return _timeInterval;
}

-(NSMutableArray *)imagesM{
    if (_imagesM == nil) {
        _imagesM = [[NSMutableArray alloc] init];
    }
    return _imagesM;
}

-(NSMutableArray *)callBackM{
    if (_callBackM == nil) {
        _callBackM = [[NSMutableArray alloc] init];
    }
    return _callBackM;
}
-(NSMutableArray *)titleM{
    if (_titleM == nil) {
        _titleM = [[NSMutableArray alloc] init];
    }
    return _titleM;
}


-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [UIColor colorWithRed:220 green:220 blue:220 alpha:0.5];
        [self addSubview:v];
        NSLayoutConstraint *vLeft = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:v.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        NSLayoutConstraint *vRight = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:v.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        NSLayoutConstraint *vBottom = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:v.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        v.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [v addSubview:titleLabel];
        _titleLabel = titleLabel;
        titleLabel.textColor = [UIColor whiteColor];
        NSLayoutConstraint *horizontal = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:titleLabel.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:titleLabel.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        self.titleLBottom = bottom;
        NSLayoutConstraint *vHeight = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:titleLabel.superview attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        
        [NSLayoutConstraint activateConstraints:@[vLeft, vRight, vBottom, horizontal, bottom, vHeight]];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return _titleLabel;
}


#pragma mark - 设置 title 样式
-(void)setTitle:(NSString *)title{
    title = title;
    self.titleLabel.text = title;
}



@end

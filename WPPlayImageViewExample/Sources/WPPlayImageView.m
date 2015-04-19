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
    PIV.clipsToBounds = YES;
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


@end

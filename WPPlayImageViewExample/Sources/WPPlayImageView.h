//
//  WPPlayImageView.h
//  图片轮播
//
//  Created by iyouwp on 15/4/17.
//  Copyright (c) 2015年 iyouwp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Frame.h"

typedef NS_ENUM(NSInteger, PlayImageViewDirection){
    PlayImageViewDirectionRight,
    PlayImageViewDirectionLeft
};

typedef NS_ENUM(NSInteger, PlayImageViewType) {
    PlayImageViewTypeSlide,
    PlayImageViewTypeFold
};

typedef void (^touchUpInsideCallBack)();

@interface WPPlayImageView : UIView


/** 目前需要传入的是 图片名字 */
@property(nonatomic, strong)NSArray *images;
/** 图片轮播的间隔时间，默认为 2 秒 */
@property(nonatomic, assign)double timeInterval;
/** 图片轮播的动画持续时间，默认为 0.5 秒 */
@property(nonatomic, assign)double duration;
/** 轮播的方向 */
@property(nonatomic, assign)PlayImageViewDirection direction;
/** 类型 */
@property(nonatomic, assign)PlayImageViewType type;


@property(weak, nonatomic) UILabel *titleLabel;
@property(nonatomic, strong)UIColor *titleColor;
@property(nonatomic, strong)UIColor *titleBackGroundColor;
@property(nonatomic, strong)UIFont *titleFont;


@property(nonatomic, strong)NSArray *titles;
///////  回调的集合
@property(nonatomic, strong)NSArray *callBacks;

///  快速创建方法
+(instancetype)playImageViewType:(PlayImageViewType)type;

-(void)addImage:(NSString *)imageName touchCallBack:(void (^)()) callBack;
-(void)addImage:(NSString *)imageName title:(NSString *)title touchCallBack:(void (^)()) callBack;

@end

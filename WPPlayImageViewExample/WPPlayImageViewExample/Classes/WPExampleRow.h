//
//  WPExampleRow.h
//  WPPlayImageViewExample
//
//  Created by iyouwp on 15/4/19.
//  Copyright (c) 2015年 iyouwp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPPlayImageView.h"
@interface WPExampleRow : NSObject

@property(nonatomic, assign)PlayImageViewType type;
@property(nonatomic, assign)PlayImageViewDirection direction;
@property(nonatomic, copy)NSString *title;

+(instancetype)exampleRowWithType:(PlayImageViewType) type diretion:(PlayImageViewDirection) direction title:(NSString *)title;

@end

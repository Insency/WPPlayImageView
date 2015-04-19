//
//  WPExampleRow.m
//  WPPlayImageViewExample
//
//  Created by iyouwp on 15/4/19.
//  Copyright (c) 2015年 iyouwp. All rights reserved.
//

#import "WPExampleRow.h"

@implementation WPExampleRow

+(instancetype)exampleRowWithType:(PlayImageViewType) type diretion:(PlayImageViewDirection) direction title:(NSString *)title{
    WPExampleRow *ER = [[WPExampleRow alloc] init];
    ER.type = type;
    ER.direction = direction;
    ER.title = title;
    return ER;
}

@end

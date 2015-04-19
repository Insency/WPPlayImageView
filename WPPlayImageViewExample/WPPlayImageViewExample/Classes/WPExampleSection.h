//
//  WPExampleSection.h
//  WPPlayImageViewExample
//
//  Created by iyouwp on 15/4/19.
//  Copyright (c) 2015年 iyouwp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WPExampleRow;

@interface WPExampleSection : NSObject

@property(nonatomic, copy)NSString *header;
@property(nonatomic, strong)NSArray *rowModels;

@end

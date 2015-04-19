//
//  WPTestViewController.m
//  WPPlayImageViewExample
//
//  Created by iyouwp on 15/4/19.
//  Copyright (c) 2015年 iyouwp. All rights reserved.
//

#import "WPTestViewController.h"
#import "WPExampleRow.h"
#import "WPPlayImageView.h"


@interface WPTestViewController ()

@end

@implementation WPTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试控制器";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    [self setupPlayImage];
}

- (void)close
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)setupPlayImage{
    WPPlayImageView *v = [WPPlayImageView playImageViewType:self.model.type];
    v.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 250);
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:v];
    v.direction = self.model.direction;
    [v addImage:@"01" title:@"我是第01张图片" touchCallBack:^{
        NSLog(@"点击了第01张图片");
    }];
    [v addImage:@"02" title:@"我是第02张图片" touchCallBack:^{
        NSLog(@"点击了第02张图片");
    }];
    [v addImage:@"03" title:@"我是第03张图片" touchCallBack:^{
        NSLog(@"点击了第01张图片");
    }];
    [v addImage:@"04" title:@"我是第04张图片" touchCallBack:^{
        NSLog(@"点击了第04张图片");
    }];
    [v addImage:@"05" title:@"我是第05张图片" touchCallBack:^{
        NSLog(@"点击了第05张图片");
    }];
    [v addImage:@"06" title:@"我是第06张图片" touchCallBack:^{
        NSLog(@"点击了第06张图片");
    }];
    [v addImage:@"07" title:@"我是第07张图片" touchCallBack:^{
        NSLog(@"点击了第07张图片");
    }];
    [v addImage:@"08" title:@"我是第08张图片" touchCallBack:^{
        NSLog(@"点击了第08张图片");
    }];
    [v addImage:@"09" title:@"我是第09张图片" touchCallBack:^{
        NSLog(@"点击了第09张图片");
    }];
    [v addImage:@"10" title:@"我是第10张图片" touchCallBack:^{
        NSLog(@"点击了第10张图片");
    }];
}

-(void)dealloc{
    NSLog(@"TestViewController 88");
}


@end

//
//  WPMainViewController.m
//  WPPlayImageViewExample
//
//  Created by iyouwp on 15/4/19.
//  Copyright (c) 2015年 iyouwp. All rights reserved.
//

#import "WPMainViewController.h"
#import "WPExampleRow.h"
#import "WPExampleSection.h"
#import "WPTestViewController.h"

@interface WPMainViewController ()

@property(nonatomic, strong)NSArray *exams;

@end

@implementation WPMainViewController

-(NSArray *)exams{
    if (!_exams) {
        WPExampleSection *exam0 = [[WPExampleSection alloc] init];
        exam0.header = @"折叠（Fold）";
        WPExampleRow *exam00 = [WPExampleRow exampleRowWithType:PlayImageViewTypeFold diretion:PlayImageViewDirectionLeft title:@"向左滑"];
        WPExampleRow *exam01 = [WPExampleRow exampleRowWithType:PlayImageViewTypeFold diretion:PlayImageViewDirectionRight title:@"向右滑"];
        exam0.rowModels = @[exam00, exam01];
       
        WPExampleSection *exam1 = [[WPExampleSection alloc] init];
        exam1.header = @"滑动（Slide）";
        WPExampleRow *exam10 = [WPExampleRow exampleRowWithType:PlayImageViewTypeSlide diretion:PlayImageViewDirectionLeft title:@"向左滑"];
        WPExampleRow *exam11 = [WPExampleRow exampleRowWithType:PlayImageViewTypeSlide diretion:PlayImageViewDirectionRight title:@"向右滑"];
        exam1.rowModels = @[exam10, exam11];
        
        _exams = @[exam0, exam1];
    }
    return _exams;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.exams.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WPExampleSection *ES = self.exams[section];
    return ES.rowModels.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    WPExampleSection *ES = self.exams[section];
    return ES.header;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    WPExampleSection *ES = self.exams[indexPath.section];
    WPExampleRow *ER = ES.rowModels[indexPath.row];
    
    cell.textLabel.text = ER.title;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WPTestViewController *vc = [[WPTestViewController alloc] init];
    WPExampleSection *ES = self.exams[indexPath.section];
    WPExampleRow *ER = ES.rowModels[indexPath.row];
    vc.model = ER;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

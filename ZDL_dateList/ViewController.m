//
//  ViewController.m
//  ZDL_dateList
//
//  Created by zhangdaliang on 2017/8/3.
//  Copyright © 2017年 yshow. All rights reserved.
//

#import "ViewController.h"
#import "DateListView.h"

@interface ViewController ()
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) UIView  *bgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArray = @[
                       @{@"month":@"7",@"price":@"98.5",@"data":
                             @[@{@"id":@"94575",@"price_adult_list": @"132",@"start_time": @"2017-07-12"},
                               @{@"id":@"94573",@"price_adult_list": @"98.5",@"start_time": @"2017-07-02"}
                                 ]},
                       @{@"month":@"10",@"price":@"126.5",@"data":
                             @[@{@"id":@"94585",@"price_adult_list": @"322",@"start_time": @"2017-10-16"},
                               @{@"id":@"94583",@"price_adult_list": @"126.5",@"start_time": @"2017-10-01"}
                               ]},
                       @{@"month":@"12",@"price":@"1099.5",@"data":
                             @[@{@"id":@"94595",@"price_adult_list": @"3092",@"start_time": @"2017-12-09"},
                               @{@"id":@"94583",@"price_adult_list": @"1099.5",@"start_time": @"2017-12-22"}
                               ]},];
    
    self.selectIndex = 0;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    self.bgView = bgView;
    [self.view addSubview:bgView];
    
    for (NSInteger i = 0; i<self.dataArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(80*i, 0, 80, 32);
        NSString *title = [NSString stringWithFormat:@"%@月份",self.dataArray[i][@"month"]];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:title forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        btn.tag = 10+i;
        [bgView addSubview:btn];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(80*i, 32, 80, 14)];
        lb.textColor = [UIColor redColor];
        lb.font = [UIFont systemFontOfSize:12];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.text = [NSString stringWithFormat:@"￥%@起",self.dataArray[i][@"price"]];
        [bgView addSubview:lb];
    }
    
    
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(80*self.selectIndex, 48, 80, 2)];
    bottomView.backgroundColor = [UIColor redColor];
    bottomView.tag = 1;
    [bgView addSubview:bottomView];
    
    
    
}
-(void)changeValue:(NSInteger)index{
    if (index == self.selectIndex) {
        return;
    }
    self.selectIndex = index;
    UIView *view = [self.bgView viewWithTag:1];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = view.frame;
        frame.origin.x = 80*self.selectIndex;
        view.frame = frame;
    }];
}
-(void)btnAction:(UIButton *)sender{
    
    NSInteger index = sender.tag - 10;
    [self changeValue:index];
    [DateListView dateListViewWithData:self.dataArray[index] frame:self.bgView.frame block:^(NSString *dateStr) {
        NSLog(@"%@",dateStr);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

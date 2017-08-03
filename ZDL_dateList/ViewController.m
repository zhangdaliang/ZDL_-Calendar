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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)Action:(UIButton *)sender {
    [DateListView dateListViewWithData:@[] frame:CGRectMake(0, sender.frame.origin.y+45, 200, 100) block:^(NSString *dateStr) {
        [sender setTitle:dateStr forState:(UIControlStateNormal)];
        NSLog(@"--选择了日历时间：%@",dateStr);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

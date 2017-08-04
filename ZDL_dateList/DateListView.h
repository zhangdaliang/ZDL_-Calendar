//
//  DateListView.h
//  ZDL_dateList
//
//  Created by zhangdaliang on 2017/8/3.
//  Copyright © 2017年 yshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateListView : UIView

+(instancetype)dateListViewWithData:(NSDictionary *)data frame:(CGRect)frame block:(void(^)(NSString *dateStr))block;

@end

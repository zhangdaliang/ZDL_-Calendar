//
//  DateListView.m
//  ZDL_dateList
//
//  Created by zhangdaliang on 2017/8/3.
//  Copyright © 2017年 yshow. All rights reserved.
//

#import "DateListView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface DateListView()
@property (nonatomic,strong) NSDate     *beginDate;
@property (nonatomic,strong) UIView     *contentView;
@property (nonatomic,strong) NSArray    *dataArray;
@property (nonatomic,assign) NSInteger  month;
@property (nonatomic,  copy) void (^dateBlock)(NSString *);
@end

@implementation DateListView


+(instancetype)dateListViewWithData:(NSDictionary *)data frame:(CGRect)frame block:(void (^)(NSString *dateStr))block
{
    DateListView *dv = [[[self class] alloc] initWithFrame:frame];
    dv.dateBlock = block;
    dv.month = [data[@"month"] integerValue];
    dv.dataArray = data[@"data"];
    [dv show];
    return dv;
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        UIView *bgView = [[UIView alloc]initWithFrame:self.bounds];
        bgView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0];
        [self addSubview:bgView];
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.origin.y+51, SCREEN_WIDTH, 0)];
        contentView.backgroundColor = [UIColor whiteColor];
        self.contentView = contentView;
        [self addSubview:contentView];
        
    }
    return self;
}

- (NSDate *)dateForIndex:(NSInteger)index
{
    
    NSInteger week = [self weakDay:self.beginDate];
    NSDate *firstDate = [self dateByAddingDays:-(week-1) date:self.beginDate];
    return [self dateByAddingDays:index date:firstDate];
}

-(void)reloadDateView{
    
    
    NSDate *date = [NSDate date];
    self.beginDate = [self dateWithString:[NSString stringWithFormat:@"%ld-%02ld-%02d",[self year:date],self.month,1] format:@"yyyy-MM-dd"];
    
    NSDate *lastDate = [self dateByAddingDays:-1 date:[self dateByAddingMonths:1 date:self.beginDate]];
    
//    NSLog(@"lastDate=%@",[self stringWithFormat:@"yyyy-MM-dd" date:lastDate]);

    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.firstWeekday = 7;
    NSInteger weekNum = [[calendar components:NSCalendarUnitWeekOfMonth fromDate:lastDate] weekOfMonth];
    
    NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    
    CGFloat itemWidth = SCREEN_WIDTH/7;
    
    
    for (NSInteger i = 0; i<(weekNum+2)*7; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        btn.frame = CGRectMake((SCREEN_WIDTH-280)/8*(i%7+1)+40*(i%7), (i/7+0.1)*itemWidth, 40, 40);
        [btn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        if(i<7){
            [btn setTitle:weekArray[i] forState:UIControlStateNormal];
        }else{
            NSInteger index = i-7;
            NSDate *date = [self dateForIndex:index];
             NSLog(@"lastDate=%@",[self stringWithFormat:@"yyyy-MM-dd" date:date]);
            if ([self month:self.beginDate] == [self month:date]) {
                btn.tag = index+1;
                [btn setTitle:[@([self day:date]) stringValue] forState:UIControlStateNormal];
                //逻辑判断
                for (NSInteger i=0; i<self.dataArray.count; i++) {
                    NSString *timeStr = [self stringWithFormat:@"yyyy-MM-dd" date:date];
                    if ([timeStr isEqualToString:self.dataArray[i][@"start_time"]]) {
                        UILabel *lb = [[UILabel alloc]init];
                        lb.textColor = [UIColor redColor];
                        lb.font = [UIFont systemFontOfSize:9];
                        lb.text = [NSString stringWithFormat:@"￥%@",self.dataArray[i][@"price_adult_list"]];
                        lb.textAlignment = NSTextAlignmentCenter;
                        lb.frame = CGRectMake(0, 30, 40, 11);
                        [btn addSubview:lb];
                        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                        [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];

                    }
                }
            }
            
        }
    }
    

}
-(void)show{
    
    [[UIApplication sharedApplication].windows.firstObject addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
        CGRect frame = self.contentView.frame;
        frame.size.height = 380;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self reloadDateView];
    }];
    
    
    
}
-(void)dismiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        CGRect frame = self.contentView.frame;
        frame.size.height = 0;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (!CGRectContainsPoint(self.contentView.frame, [touch locationInView:self])) {
        [self dismiss];
    }
}

-(void)btnAction:(UIButton *)sender{
    NSDate *selectDate = [self dateForIndex:sender.tag-1];
    NSString *dateStr = [self stringWithFormat:@"yyyy-MM-dd" date:selectDate];
    /*
     *在此判断点击逻辑
     */
    
    if (self.dateBlock) {
        self.dateBlock(dateStr);
    }
}
#pragma -mark date工具
- (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}
- (NSString *)stringWithFormat:(NSString *)format date:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:date];
}

//获取日期的年
- (NSInteger)year:(NSDate *)date {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date] year];
}
//获取日期的月
- (NSInteger)month:(NSDate *)date{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:date] month];
}
//获取日期的天
- (NSInteger)day:(NSDate *)date{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:date] day];
}
//获取日期是在周几
- (NSInteger)weakDay:(NSDate *)date{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date] weekday];
}

//date增加一月
- (NSDate *)dateByAddingMonths:(NSInteger)months date:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:date options:0];
}
//天数拼接计算
- (NSDate *)dateByAddingDays:(NSInteger)days date:(NSDate *)date{
    NSTimeInterval aTimeInterval = [date timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

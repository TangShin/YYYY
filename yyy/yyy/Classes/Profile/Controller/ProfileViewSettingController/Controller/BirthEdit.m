//
//  BirthEdit.m
//  yyy
//
//  Created by TangXing on 16/3/24.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "BirthEdit.h"

#define kPVH (kScreenHeight * 0.35>230?230:(kScreenHeight * 0.35<200?200:kScreenHeight * 0.35))

@interface BirthEdit ()

@property (strong,nonatomic) UILabel *dateLabel;
@property (strong,nonatomic) UIDatePicker *datePicker;

@end

@implementation BirthEdit

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YYYBackGroundColor;
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 40)];
    _dateLabel.backgroundColor = [UIColor whiteColor];
    _dateLabel.font = [UIFont systemFontOfSize:16.0];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.textColor = [UIColor blackColor];
    _dateLabel.text = _birthday;
    [self.view addSubview:_dateLabel];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreenHeight - kPVH, kScreenWidth, kPVH)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [_datePicker addTarget:self action:@selector(dateChangeValue:) forControlEvents:UIControlEventValueChanged];
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *selectDate = [formatter dateFromString:_birthday];
    
    _datePicker.date = selectDate;
    
    NSDate *maxDate = [NSDate new];
    _datePicker.maximumDate = maxDate;
    
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    [_datePicker setDate:selectDate animated:YES];
    
    [self.view addSubview:_datePicker];
}

- (void)dateChangeValue:(id)sender
{
    _dateLabel.text = [self dateStringWithDate:[sender date] DateFormat:@"yyyy-MM-dd"];
}

- (void)dateChange:(id)sender
{
    if (_delegate) {
        [_delegate dateChange:sender];
    }
}

- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dateChange:_dateLabel.text];
}
@end

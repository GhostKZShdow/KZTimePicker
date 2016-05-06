//
//  KTimePickerView.m
//  时间选择器
//
//  Created by 张坤 on 16/2/23.
//  Copyright © 2016年 KZ. All rights reserved.
//

#import "KTimePickerView.h"

#define buttonWidth 50
#define buttonHeight 30
#define buttonSpace 15
@interface KTimePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    CGRect _frame;
    
    UIButton *_certainButton;
    UIButton *_cancelButton;
    
    UIPickerView *_pickerView;
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;
    NSMutableArray *_dayArray;
    NSMutableArray *_hourArray;
    NSMutableArray *_minuteArray;
    NSMutableArray *_secondArray;

    NSInteger _currentMonth;
    
    NSInteger _selectYearRow;
    NSInteger _selectMonthRow;
    NSInteger _selectDayRow;
    
    NSString *_showTimeString;
    
    BOOL _isFirstTimeLoad;//是否是第一次加载
}
@end

@implementation KTimePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    _frame = frame;
    self = [super initWithFrame:frame];
    if (self) {
        [self addContentView];
    }
    return self;
}
- (void)addContentView{
    self.alpha = 0;
    [self setBackgroundColor:[UIColor whiteColor]];
    UIView *chooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _frame.size.width, buttonHeight)];
    [self addSubview:chooseView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, buttonHeight, _frame.size.width, .6)];
    lineView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.4];
    [self addSubview:lineView];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setFrame:CGRectMake(buttonSpace, 0, buttonWidth, buttonHeight)];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [chooseView addSubview:_cancelButton];
    
    _certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_certainButton setFrame:CGRectMake(_frame.size.width - buttonWidth - buttonSpace, 0, buttonWidth, buttonHeight)];
    [_certainButton setTitle:@"确定" forState:UIControlStateNormal];
    [_certainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_certainButton addTarget:self action:@selector(certainButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [chooseView addSubview:_certainButton];
    
    
    
    _isFirstTimeLoad = YES;
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(5, buttonHeight, _frame.size.width - 10, _frame.size.height - buttonHeight)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [self addSubview:_pickerView];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //当前的年份
    [formatter setDateFormat:@"yyyy"];
    NSString *currentYearString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    //当前的月份
    [formatter setDateFormat:@"MM"];
    NSString *currentMonthString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    _currentMonth = [currentMonthString integerValue];
//    NSLog(@"-------%lu",_currentMonth);
    //当前的日
    [formatter setDateFormat:@"dd"];
    NSString *currentDayString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    //当前的时
    [formatter setDateFormat:@"HH"];
    NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    //当前的分
    [formatter setDateFormat:@"mm"];
    NSString *currentMinuteString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    //当前的秒
    [formatter setDateFormat:@"ss"];
    NSString *currentSecondString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    _showTimeString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/",currentYearString,currentMonthString,currentDayString,currentHourString,currentMinuteString,currentSecondString];
//    NSLog(@"%@",_showTimeString);
    _yearArray = [[NSMutableArray alloc]init];
    int currentYear = [currentYearString intValue];
    for (int i=2005; i<=currentYear; i++) {
        [_yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _monthArray = [[NSMutableArray alloc]init];
    for (int i=1; i<=12; i++) {
        [_monthArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _dayArray = [[NSMutableArray alloc]init];
    for (int i=1; i<=31; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _hourArray = [[NSMutableArray alloc]init];
    for (int i=0; i<24; i++) {
        [_hourArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _minuteArray = [[NSMutableArray alloc]init];
    for (int i=0; i<60; i++) {
        [_minuteArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _secondArray = [[NSMutableArray alloc]init];
    for (int i=0; i<60; i++) {
        [_secondArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    if ([currentMonthString hasPrefix:@"0"]) {
        currentMonthString = [currentMonthString substringFromIndex:1];
    }
    if ([currentDayString hasPrefix:@"0"]) {
        currentDayString = [currentDayString substringFromIndex:1];
    }
    if ([currentHourString hasPrefix:@"0"]) {
        currentHourString = [currentHourString substringFromIndex:1];
    }
    if ([currentMinuteString hasPrefix:@"0"]) {
        currentMinuteString = [currentMinuteString substringFromIndex:1];
    }
    if ([currentSecondString hasPrefix:@"0"]) {
        currentSecondString  = [currentSecondString substringFromIndex:1];
    }
    [_pickerView selectRow:[_yearArray indexOfObject:currentYearString] inComponent:0 animated:YES];
    [_pickerView selectRow:[_monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
    [_pickerView selectRow:[_dayArray indexOfObject:currentDayString] inComponent:2 animated:YES];
    [_pickerView selectRow:[_hourArray indexOfObject:currentHourString] inComponent:3 animated:YES];
    [_pickerView selectRow:[_minuteArray indexOfObject:currentMinuteString] inComponent:4 animated:YES];
    [_pickerView selectRow:[_secondArray indexOfObject:currentSecondString] inComponent:5 animated:YES];
}
- (void)cancelButtonClicked{
    [self hide];
}
- (void)certainButtonClicked{
    _showTimeString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",[_yearArray objectAtIndex:[_pickerView selectedRowInComponent:0]],[_monthArray objectAtIndex:[_pickerView selectedRowInComponent:1]],[_dayArray objectAtIndex:[_pickerView selectedRowInComponent:2]],[_hourArray objectAtIndex:[_pickerView selectedRowInComponent:3]],[_minuteArray objectAtIndex:[_pickerView selectedRowInComponent:4]],[_secondArray objectAtIndex:[_pickerView selectedRowInComponent:5]]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(KTimePickerViewCertainButtonClicked:)]) {
        [self.delegate KTimePickerViewCertainButtonClicked:_showTimeString];
    }
}
- (void)showInView:(UIView *)view{
    self.alpha = 1;
    [view addSubview:self];
}
- (void)hide{
    self.alpha = 0;
    [self removeFromSuperview];
}
#pragma mark-UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 6;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    NSLog(@"%lu--%lu--%lu",_currentMonth,component,_selectMonthRow);
    if (component == 0) {
        return _yearArray.count;
    }
    else if (component == 1) {
        return _monthArray.count;
    }
    else if (component == 2) {
        if (_isFirstTimeLoad) {
            if (_currentMonth == 1 || _currentMonth == 3 || _currentMonth == 5 || _currentMonth==7 || _currentMonth==8 || _currentMonth== 10 || _currentMonth== 12) {
                return 31;
            }
            else if (_currentMonth == 2) {
                NSInteger chooseYear = [_yearArray[_selectYearRow] integerValue];
                if (((chooseYear%4==0)&&(chooseYear%100!=0))||(chooseYear%400==0)) {
                    return 29;
                }
                else {
                    return 28;
                }
            }
            else {
                return 30;
            }
        }
        else {
            if (_selectMonthRow == 0 || _selectMonthRow == 2 || _selectMonthRow == 4 || _selectMonthRow == 6 || _selectMonthRow == 7 || _selectMonthRow == 9 || _selectMonthRow == 11) {
                return 31;
            }
            else if (_selectMonthRow == 1) {
                NSInteger chooseYear = [_yearArray[_selectYearRow] integerValue];
                if (((chooseYear%4==0)&&(chooseYear%100!=0))||(chooseYear%400==0)) {
                    return 29;
                }
                else {
                    return 28;
                }
            }
            else {
                return 30;
            }
        }
    }
    else if (component == 3) {
        return _hourArray.count;
    }
    else if (component == 4) {
        return _minuteArray.count;
    }
    else {
        return _secondArray.count;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *showLabel = (UILabel *)view;
    if (showLabel == nil) {
        
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/6 - 10, 60);
        showLabel = [[UILabel alloc]initWithFrame:frame];
        [showLabel setTextAlignment:NSTextAlignmentCenter];
        [showLabel setBackgroundColor:[UIColor clearColor]];
        [showLabel setFont:[UIFont systemFontOfSize:15]];
    }
    if (component == 0) {
        showLabel.text = [NSString stringWithFormat:@"%@年",[_yearArray objectAtIndex:row]];
    } else if (component == 1) {
        showLabel.text = [NSString stringWithFormat:@"%@月",[_monthArray objectAtIndex:row]];
    } else if (component == 2) {
        showLabel.text = [NSString stringWithFormat:@"%@日",[_dayArray objectAtIndex:row]];
    } else if (component == 3) {
        showLabel.text = [NSString stringWithFormat:@"%@时",[_hourArray objectAtIndex:row]];
    } else if (component == 4) {
        showLabel.text = [NSString stringWithFormat:@"%@分",[_minuteArray objectAtIndex:row]];
    } else {
        showLabel.text = [NSString stringWithFormat:@"%@秒",[_secondArray objectAtIndex:row]];
    }
    return showLabel;
}
#pragma mark-UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    NSLog(@"%lu",row);
    if (component == 0) {
        _selectYearRow = row;
        [_pickerView reloadAllComponents];
    } else if (component == 1) {
        _isFirstTimeLoad = NO;
        _selectMonthRow = row;
        [_pickerView reloadAllComponents];
    } else if (component == 2) {
        _selectDayRow = row;
        [_pickerView reloadAllComponents];
    }
}

@end

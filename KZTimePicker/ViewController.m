//
//  ViewController.m
//  KZTimePicker
//
//  Created by 张坤 on 16/5/6.
//  Copyright © 2016年 KZ. All rights reserved.
//

#import "ViewController.h"
#import "KTimePickerView.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<KTimePickerViewDelegate>
{
    KTimePickerView *_timePickerView;
    
    UILabel *_showLabel;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:.6];
    //初始化时间选择器
    _timePickerView = [[KTimePickerView alloc]initWithFrame:CGRectMake(0, screenHeight -  200, screenWidth, 200)];
    _timePickerView.delegate = self;
    [_timePickerView showInView:self.view];
    
    //初始化显示时间的label
    _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
    _showLabel.center = self.view.center;
    [_showLabel setTextAlignment:NSTextAlignmentCenter];
    [_showLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:_showLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark KTimePickerViewDelegate
- (void)KTimePickerViewCertainButtonClicked:(NSString *)timeString{
    [_showLabel setText:timeString];
}

@end

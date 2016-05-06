//
//  KTimePickerView.h
//  时间选择器
//
//  Created by 张坤 on 16/2/23.
//  Copyright © 2016年 KZ. All rights reserved.
//
//                      日期选择器

#import <UIKit/UIKit.h>

@protocol KTimePickerViewDelegate <NSObject>

- (void)KTimePickerViewCertainButtonClicked:(NSString *)timeString;

@end

@interface KTimePickerView : UIView

@property (nonatomic, assign) id delegate;

- (void)showInView:(UIView *)view;

- (void)hide;

@end

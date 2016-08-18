//
//  InputText.m
//  yyy
//
//  Created by TangXing on 15/11/10.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "InputText.h"

@implementation InputText

- (UITextField *)setupWithIcon:(NSString *)icon textY:(CGFloat)textY centerX:(CGFloat)centerX point:(NSString *)point;
{
    UITextField *textField = [[UITextField alloc] init];
    textField.width = kScreenWidth - 60;
    textField.height = 50;
    textField.centerX = centerX;
    textField.y = textY;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 36, kScreenWidth - 60, 2)];
    view.alpha = 0.5;
//    view.backgroundColor = YYYColor(154, 216, 245);
    view.backgroundColor = YYYMainColor;
    [textField addSubview:view];
    textField.placeholder = point;
    textField.font = [UIFont systemFontOfSize:18];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIImage *bigIcon = [UIImage imageNamed:icon];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:bigIcon];
    if (icon) {
        iconView.width = 34;
    }
    iconView.contentMode = UIViewContentModeLeft;
    textField.leftView = iconView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

@end

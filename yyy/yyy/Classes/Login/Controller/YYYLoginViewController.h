//
//  YYYLoginViewController.h
//  yyy
//
//  Created by TangXing on 15/10/27.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYLoglnButton.h"

@interface YYYLoginViewController : UIViewController

@property (weak,nonatomic) UIImageView *logoImage;

@property (weak,nonatomic) UITextField *userField;
@property (weak,nonatomic) UILabel *userTextName;

@property (weak,nonatomic) UITextField *psdField;
@property (weak,nonatomic) UILabel *passwordTextName;

@property (weak,nonatomic) UITextField *authField;
@property (weak,nonatomic) UILabel *authTextName;

@property (weak,nonatomic) UITextField *psdFieldAgain;
@property (weak,nonatomic) UILabel *passwordTextNameAgain;

@property (nonatomic, assign) BOOL chang;
@property (nonatomic, assign) BOOL registState;

@property (strong,nonatomic) UIButton *loginBtn;
@property (strong,nonatomic) UIButton *registBtn;
@property (strong,nonatomic) UIButton *forgetPsd;
@property (strong,nonatomic) UIButton *registDelegateBtn;
@property (strong,nonatomic) UIButton *delegateBtn;

@property (strong,nonatomic) YYYLoglnButton *log;
@property (strong,nonatomic) YYYLoglnButton *regist;

@property (strong,nonatomic) UIView *backView;
@property (strong,nonatomic) UIView *lineView;
@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UIButton *backBtn;

@property (assign,nonatomic) CGFloat offset;

@end
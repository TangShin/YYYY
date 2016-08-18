//
//  YYYLoginViewController.m
//  yyy
//
//  Created by TangXing on 15/10/27.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "YYYLoginViewController.h"
#import "YYYTabBarController.h"
#import "YYYTransitions.h"
#import "WSProgressHUD.h"
#import "UserInfoTool.h"
#import "YYYHttpTool.h"
#import "InputText.h"
#import "AuthCode.h"

#define fieldX 30;
#define fieldY 10;

@interface YYYLoginViewController () <UIViewControllerTransitioningDelegate,UITextFieldDelegate>

@property (assign,nonatomic) int keyboardH;
@property (strong,nonatomic) AuthCode *authCodeView;

@end

@implementation YYYLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //是否时注册状态,一进入是登录界面
    //    self.registState = NO;
    if (self.registState == NO) {
        [self buildUI];
    } else {
        [self buildUI];
        [self loginToRegist];
    }
    
}

- (void)PresentViewController:(YYYLoglnButton *)button{
    
    [self.view endEditing:YES];
    
    if (!self.registState) {
        [self loginOrRegist:button];
        return;
    }
    
    if (![self isValidateEmail:self.userField.text]) {
        [WSProgressHUD showImage:nil status:@"请输入正确的邮箱"];
        [button ErrorRevertAnimationCompletion:^{
            [self didPresentControllerButtonTouch];
        }];
        return;
    }
    if (![self isEqualPasswordOnce:self.psdField.text PasswordTwice:self.psdFieldAgain.text]) {
        [WSProgressHUD showImage:nil status:@"两次输入的密码不一致"];
        [button ErrorRevertAnimationCompletion:^{
            [self didPresentControllerButtonTouch];
        }];
        return;
    }
    [self loginOrRegist:button];
}

- (void)loginOrRegist:(YYYLoglnButton *)button
{
    NSDictionary *prameters = [[NSDictionary alloc] init];
    if (!self.registState) {
        prameters = [NSDictionary dictionaryWithObjectsAndKeys:_userField.text,@"loginUserValue.loginUserName",_psdField.text,@"loginUserValue.password",_authField.text,@"loginUserValue.veriCode",nil];
    } else {
        prameters = [NSDictionary dictionaryWithObjectsAndKeys:_userField.text,@"loginUserValue.loginUserName",_psdField.text,@"loginUserValue.password",_psdFieldAgain.text,@"loginUserValue.passwordConfirm",@"true",@"loginUserValue.regist",_authField.text,@"loginUserValue.veriCode",nil];
    }
    
    [YYYHttpTool post:YYYLoginURL params:prameters success:^(id json) {
        
        NSString *error = [json valueForKey:@"error"];
        
        if ([error intValue] == 1) {
            
            [button ErrorRevertAnimationCompletion:^{
                [self didPresentControllerButtonTouch];
            }];
            
            [WSProgressHUD showImage:nil status:[[json valueForKey:@"errorField"] valueForKey:@"value"]];
            
        } else {
            [button ExitAnimationCompletion:^{
                
                //将账号信息存储到沙盒
                UserInfo *userInfo = [UserInfo userInfoWithDict:[json valueForKey:@"userValue"]];
                [UserInfoTool saveUserInfo:userInfo];
                
                [self didPresentControllerButtonTouch];
            }];
        }
        
    } failure:^(NSError *error) {
        [WSProgressHUD showImage:nil status:@"网络连接错误"];
        [button ErrorRevertAnimationCompletion:^{
            [self didPresentControllerButtonTouch];
        }];
        
    }];
}

- (void)didPresentControllerButtonTouch
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    return [[YYYTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.5f isBOOL:true];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    return [[YYYTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.8f isBOOL:false];
}

- (void)buildUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //创建logo
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 75)/2, 74, 75, 75)];
    [logoImage setImage:[UIImage imageNamed:@"appicon60x60"]];
    self.logoImage = logoImage;
    [self.view addSubview:logoImage];
    
    //模拟navigationcontroller上面的view
    //1.创建顶部view
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView];
    //2.创建线
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 0.3)];
    _lineView.backgroundColor = [UIColor colorWithRed:110.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:0.8];
    [self.view addSubview:_lineView];
    //3.创建标题
    _label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 40)/2, 30, 40, 24)];
    _label.text = @"登录";
    _label.font = [UIFont systemFontOfSize:18];
    _label.textColor = [UIColor blackColor];
    [_backView addSubview:_label];
    //4.创建返回button
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setFrame:CGRectMake(10, 30, 24,24)];
    [_backBtn setBackgroundColor:[UIColor clearColor]];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backToProfileView:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_backBtn];
    
    //账号输入框
    CGFloat centerX = self.view.frame.size.width*0.5;
    InputText *inputText = [[InputText alloc] init];
    CGFloat userY = CGRectGetMaxY(_logoImage.frame) + fieldY;
    UITextField *userField = [inputText setupWithIcon:nil textY:userY centerX:centerX point:nil];
    userField.delegate = self;
    [userField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [userField setKeyboardType:UIKeyboardTypeURL];
    [userField setReturnKeyType:UIReturnKeyNext];
    self.userField = userField;
    [self.view addSubview:userField];
    
    //输入框提示文本
    UILabel *userTextName = [self setupTextName:@"邮箱" frame:_userField.frame];
    self.userTextName = userTextName;
    [self.view addSubview:userTextName];
    
    //密码输入框
    CGFloat psdY = CGRectGetMaxY(_userField.frame) + fieldY;
    UITextField *psdField = [inputText setupWithIcon:nil textY:psdY centerX:centerX point:nil];
    psdField.delegate = self;
    [psdField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [psdField setSecureTextEntry:YES];
    [psdField setKeyboardType:UIKeyboardTypeDefault];
    [psdField setReturnKeyType:UIReturnKeyNext];
    [psdField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    self.psdField = psdField;
    [self.view addSubview:psdField];
    
    //输入框提示文本
    UILabel *passwordTextName = [self setupTextName:@"密码" frame:_psdField.frame];
    self.passwordTextName = passwordTextName;
    [self.view addSubview:passwordTextName];
    
    //创建验证码输入框
    [self addAuthTextField:_psdField];
    
    //忘记密码按钮
    _forgetPsd = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forgetPsd setFrame:CGRectMake(30, CGRectGetMaxY(_authField.frame), 64, 30)];
    [_forgetPsd setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_forgetPsd setTitleColor:[UIColor colorWithRed:154.0f/255.0f green:154.0f/255.0f blue:154.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [_forgetPsd setBackgroundColor:[UIColor clearColor]];
    _forgetPsd.titleLabel.font = [UIFont systemFontOfSize:14];
    [_forgetPsd addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetPsd];
    
    //登录按钮
    _log = [[YYYLoglnButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200)/2,CGRectGetMaxY(_psdField.frame) + 105 , 200, 50)];
    [_log setBackgroundColor:[UIColor colorWithRed:154.0f/255.0f green:154.0f/255.0f blue:154.0f/255.0f alpha:1]];
    [_log setTitle:@"登录" forState:UIControlStateNormal];
    [_log addTarget:self action:@selector(PresentViewController:) forControlEvents:UIControlEventTouchUpInside];
    _log.enabled = NO;
    [self.view addSubview:_log];
    
    //登录变注册(按钮)
    _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registBtn setFrame:CGRectMake((self.view.frame.size.width - 110)/2, CGRectGetMaxY(_log.frame) + 10, 110, 30)];
    [_registBtn setTitle:@"还没有账号?注册" forState:UIControlStateNormal];
    [_registBtn setTitleColor:[UIColor colorWithRed:154.0f/255.0f green:154.0f/255.0f blue:154.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [_registBtn setBackgroundColor:[UIColor clearColor]];
    _registBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_registBtn addTarget:self action:@selector(loginToRegist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registBtn];
    
}

/**
 *  重新创建登陆按钮
 */
- (void)buildLoginUI
{
    //登录按钮
    _log = [[YYYLoglnButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200)/2,CGRectGetMaxY(_psdField.frame) + 105 , 200, 50)];
    [_log setBackgroundColor:[UIColor colorWithRed:154.0f/255.0f green:154.0f/255.0f blue:154.0f/255.0f alpha:1]];
    [_log setTitle:@"登录" forState:UIControlStateNormal];
    [_log addTarget:self action:@selector(PresentViewController:) forControlEvents:UIControlEventTouchUpInside];
    _log.enabled = NO;
    [self.view addSubview:_log];
}

- (void)addAuthTextField:(UITextField *)textField
{
    //验证码输入框
    CGFloat authY = CGRectGetMaxY(textField.frame) + fieldY;
    CGFloat authW = kScreenWidth - 90 - 10 - 30 - fieldX;
    
    InputText *inputText = [[InputText alloc] init];
    UITextField *authField = [inputText setupWithIcon:nil textY:authY centerX:self.view.frame.size.width*0.5 point:nil];
    [authField setWidth:authW];
    authField.delegate = self;
    [authField setKeyboardType:UIKeyboardTypeURL];
    [authField setReturnKeyType:UIReturnKeyNext];
    [authField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    self.authField = authField;
    [self.view addSubview:authField];
    
    //输入框提示文本
    UILabel *authTextName = [self setupTextName:@"验证码" frame:_authField.frame];
    self.authTextName = authTextName;
    [self.view addSubview:authTextName];
    
    //验证码图片
    CGFloat authCodeX = CGRectGetMaxX(_authField.frame) + 10;
    CGFloat authCodeY = authY;
    self.authCodeView = [[AuthCode alloc] initWithFrame:CGRectMake(authCodeX, authCodeY, 90, 32)];
    [self.view addSubview:self.authCodeView];
}

/**
 *  创建注册页面时的UI
 */
- (void)buildRegistUI
{
    //确认密码输入框
    CGFloat psdAgainY = CGRectGetMaxY(_psdField.frame) + fieldY;
    InputText *inputText = [[InputText alloc] init];
    UITextField *psdFieldAgain = [inputText setupWithIcon:nil textY:psdAgainY centerX:self.view.frame.size.width*0.5 point:nil];
    [psdFieldAgain setClearButtonMode:UITextFieldViewModeWhileEditing];
    [psdFieldAgain setSecureTextEntry:YES];
    [psdFieldAgain setKeyboardType:UIKeyboardTypeDefault];
    [psdFieldAgain setReturnKeyType:UIReturnKeyNext];
    psdFieldAgain.delegate = self;
    self.psdFieldAgain = psdFieldAgain;
    [psdFieldAgain addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:psdFieldAgain];
    
    //输入提示文本
    UILabel *passwordTextNameAgain = [self setupTextName:@"确认密码" frame:_psdFieldAgain.frame];
    self.passwordTextNameAgain = passwordTextNameAgain;
    [self.view addSubview:passwordTextNameAgain];

    [self addAuthTextField:_psdFieldAgain];
    
    //协议按钮前部
    _registDelegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registDelegateBtn.frame = CGRectMake(30, CGRectGetMaxY(_authField.frame)-20, 180, 50);
    [_registDelegateBtn setTitle:@"点击\"注册\"按钮，即表示同意" forState:UIControlStateNormal];
    [_registDelegateBtn setTitleColor:[UIColor colorWithRed:154.0f/255.0f green:154.0f/255.0f blue:154.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [_registDelegateBtn addTarget:self action:@selector(agreeDelegate:) forControlEvents:UIControlEventTouchUpInside];
    _registDelegateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _registDelegateBtn.tag = 10;
    [self.view addSubview:_registDelegateBtn];
    
    //协议按钮后部
    _delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _delegateBtn.frame = CGRectMake(208, CGRectGetMaxY(_authField.frame)-20, 60, 50);
    [_delegateBtn setTitle:@"注册协议" forState:UIControlStateNormal];
    [_delegateBtn setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [_delegateBtn addTarget:self action:@selector(agreeDelegate:) forControlEvents:UIControlEventTouchUpInside];
    _delegateBtn.tag = 11;
    _delegateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_delegateBtn];
    
    //注册按钮
    _regist = [[YYYLoglnButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200)/2,CGRectGetMaxY(_authField.frame) + 30 , 200, 50)];
    [_regist setBackgroundColor:[UIColor colorWithRed:154.0f/255.0f green:154.0f/255.0f blue:154.0f/255.0f alpha:1]];
    [_regist setTitle:@"注册" forState:UIControlStateNormal];
    [_regist addTarget:self action:@selector(PresentViewController:) forControlEvents:UIControlEventTouchUpInside];
    _regist.enabled = NO;
    [self.view addSubview:_regist];
    
    //注册变登录(按钮)
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setFrame:CGRectMake((self.view.frame.size.width - 100)/2, CGRectGetMaxY(_regist.frame) + 10, 100, 30)];
    [_loginBtn setTitle:@"已有账号?登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor colorWithRed:154.0f/255.0f green:154.0f/255.0f blue:154.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [_loginBtn setBackgroundColor:[UIColor clearColor]];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_loginBtn addTarget:self action:@selector(registToLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
}

/**
 *  登录界面变注册界面
 *
 *  @param sender 被点击的按钮
 */
- (void)loginToRegist
{
    //此时是注册界面
    self.registState = YES;
    
    //隐藏登录界面时的部分按钮并且清空输入框
    self.log.hidden = YES;
    self.registBtn.hidden = YES;
    self.forgetPsd.hidden = YES;
    self.userField.text = @"";
    self.psdField.text = @"";
    
    [self.authField removeFromSuperview];
    [self.authTextName removeFromSuperview];
    [self.authCodeView removeFromSuperview];
    
    //创建注册界面UI
    [self buildRegistUI];
    
    //使输入文本提示回到原来位置
    [self restoreTextName:self.userTextName textField:self.userField];
    [self restoreTextName:self.passwordTextName textField:self.psdField];
    [self restoreTextName:self.authTextName textField:self.authField];
    [self restoreTextName:self.passwordTextNameAgain textField:self.psdFieldAgain];
    
    //使输入框失去焦点，防止BUG
    [self.userField resignFirstResponder];
    [self.psdField resignFirstResponder];
    
}

/**
 *  注册界面变登录界面
 *
 *  @param sender 被点击对按钮
 */
- (void)registToLogin:(UIButton *)sender
{
    //此时不是登录界面
    self.registState = NO;
    
    //删除注册界面创建的UI
    [self.psdFieldAgain removeFromSuperview];
    [self.passwordTextNameAgain removeFromSuperview];
    [self.authField removeFromSuperview];
    [self.authTextName removeFromSuperview];
    [self.authCodeView removeFromSuperview];
    [self.regist removeFromSuperview];
    [self.loginBtn removeFromSuperview];
    [self.registDelegateBtn removeFromSuperview];
    [self.delegateBtn removeFromSuperview];
    
    //显示之前隐藏的UI
    _registBtn.hidden = NO;
    _forgetPsd.hidden = NO;
    
    //清空输入框
    self.userField.text = @"";
    self.psdField.text = @"";
    self.authField.text = @"";
    
    //更改验证码输入框的frame
    [self addAuthTextField:_psdField];
    
    //重新创建登录按钮
    [self buildLoginUI];
    
    //输入文本提示回到原来位置
    [self restoreTextName:self.userTextName textField:self.userField];
    [self restoreTextName:self.passwordTextName textField:self.psdField];
    [self restoreTextName:self.authTextName textField:self.authField];
    
    //使输入框失去焦点，防止BUG
    [self.userField resignFirstResponder];
    [self.psdField resignFirstResponder];
    [self.authField resignFirstResponder];
    
}

/**
 *  忘记密码点击事件
 *
 *  @param sender 被点击的按钮
 */
- (void)forgetPassword:(UIButton *)sender
{
    TSLog(@"该背时");
}

/**
 *  创建输入提示文本
 *
 *  @param textName 名字
 *  @param frame    位置，大小
 *
 *  @return 返回UILabel
 */
- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = [UIFont systemFontOfSize:16];
    textNameLabel.textColor = [UIColor grayColor];
    textNameLabel.frame = frame;
    [textNameLabel setY:frame.origin.y - 10];
    return textNameLabel;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.userField) {
        [self diminishTextName:self.userTextName];
        [self restoreTextName:self.passwordTextName textField:self.psdField];
        [self restoreTextName:self.authTextName textField:self.authField];
        [self restoreTextName:self.passwordTextNameAgain textField:self.psdFieldAgain];
    } else if (textField == self.psdField) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.userTextName textField:self.userField];
        [self restoreTextName:self.authTextName textField:self.authField];
        [self restoreTextName:self.passwordTextNameAgain textField:self.psdFieldAgain];
    } else if (textField == self.authField) {
        [self diminishTextName:self.authTextName];
        [self restoreTextName:self.userTextName textField:self.userField];
        [self restoreTextName:self.passwordTextName textField:self.psdField];
        [self restoreTextName:self.passwordTextNameAgain textField:self.psdFieldAgain];
    } else if (textField == self.psdFieldAgain) {
        [self diminishTextName:self.passwordTextNameAgain];
        [self restoreTextName:self.userTextName textField:self.userField];
        [self restoreTextName:self.authTextName textField:self.authField];
        [self restoreTextName:self.passwordTextName textField:self.psdField];
    }
    return YES;
}

/**
 *  点击return事件监听
 *
 *  @param textField 当前输入框
 *
 *  @return BOOL
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userField) {
        return [self.psdField becomeFirstResponder];
    } else if (textField == self.psdField && self.registState){
        return [self.psdFieldAgain becomeFirstResponder];
    } else if (textField == self.psdFieldAgain) {
        return [self.authField becomeFirstResponder];
    } else if (textField == self.psdField){
        return [self.authField becomeFirstResponder];
    } else {
        [self restoreTextName:self.authTextName textField:self.authField];
        return [self.authField resignFirstResponder];
    }
}

//文本动画
- (void)diminishTextName:(UILabel *)label
{
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, -16);
        label.font = [UIFont systemFontOfSize:12];
    }];
}

//文本动画
- (void)restoreTextName:(UILabel *)label textField:(UITextField *)textFieled
{
    [self textFieldTextChange:textFieled];
    if (self.chang) {
        [UIView animateWithDuration:0.5 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.font = [UIFont systemFontOfSize:16];
        }];
    }
}

- (void)textFieldTextChange:(UITextField *)textField
{
    if (textField.text.length != 0) {
        self.chang = NO;
    } else {
        self.chang = YES;
    }
}

- (void)textFieldDidChange
{
    if (self.registState) {
        if (self.userField.text.length != 0 && self.psdField.text.length >= 6 && self.psdField.text.length <= 20 && self.authField.text.length == 4)
        {
            self.regist.enabled = YES;
            [self.regist setBackgroundColor:YYYMainColor];
        } else {
            self.regist.enabled = NO;
            [self.regist setBackgroundColor:YYYColor(154, 154, 154)];
        }
    } else {
        if (self.userField.text.length != 0 && self.psdField.text.length >= 6 && self.psdField.text.length <= 20 && self.authField.text.length == 4)
        {
            self.log.enabled = YES;
            [self.log setBackgroundColor:YYYMainColor];
        } else {
            self.log.enabled = NO;
            [self.log setBackgroundColor:YYYColor(154, 154, 154)];
        }
    }
}

//避免iphone6以下键盘遮挡
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    float offset = frame.origin.y + 102 - (self.view.frame.size.height - 216);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if (offset > 0) {
        self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height + offset);
        _backView.origin = CGPointMake(0, offset);
        _lineView.origin = CGPointMake(0, offset+64);
        self.offset = offset;
    }
    
    [UIView commitAnimations];
}

//输入框失去焦点后UI界面回复
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.offset);
    self.offset = 0;
    _backView.origin = CGPointMake(0, 0);
    _lineView.origin = CGPointMake(0, 64);
}

//屏幕点击事件
#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self restoreTextName:self.userTextName textField:self.userField];
    [self restoreTextName:self.passwordTextName textField:self.psdField];
    [self restoreTextName:self.authTextName textField:self.authField];
    [self restoreTextName:self.passwordTextNameAgain textField:self.psdFieldAgain];
}

//注册协议
- (void)agreeDelegate:(UIButton *)sender
{
    TSLog(@"我拒绝");
}

//返回上级界面
- (void)backToProfileView:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

//判断是否包含@字符(注册用)
- (BOOL)isValidateEmail:(NSString *)email
{
    if ([email rangeOfString:@"@"].location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

//判断两次输入的密码是否一致(注册用)
- (BOOL)isEqualPasswordOnce:(NSString *)psdOne PasswordTwice:(NSString *)psdTwo
{
    if ([psdOne isEqual:psdTwo]) {
        return YES;
    } else {
        return NO;
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end

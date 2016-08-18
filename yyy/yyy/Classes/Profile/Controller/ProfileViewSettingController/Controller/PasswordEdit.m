//
//  PasswordEdit.m
//  yyy
//
//  Created by TangXing on 16/3/29.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "PasswordEdit.h"
#import "YYYHttpTool.h"
#import "UserInfoTool.h"
#import "WSProgressHUD.h"

@interface PasswordEdit () <UITextFieldDelegate>

@property (strong,nonatomic) UITextField *oldPsdField;
@property (strong,nonatomic) UITextField *psdField;
@property (strong,nonatomic) UITextField *psdFieldConfirm;
@property (strong,nonatomic) UIButton *confirmBtn;

@end

@implementation PasswordEdit

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YYYBackGroundColor;
    
    [self.view addSubview:[self oldPsdField]];
    [self.view addSubview:[self psdField]];
    [self.view addSubview:[self psdFieldConfirm]];
    [self.view addSubview:[self confirmBtn]];
}



- (void)psdEdit
{
    NSString *psdStr = _psdField.text;
    NSString *psdConStr = _psdFieldConfirm.text;
    if (![psdStr isEqualToString:psdConStr]) {
        [WSProgressHUD showImage:nil status:@"两次输入的新密码不一致"];
        _confirmBtn.backgroundColor = [UIColor redColor];
        return;
    }
    NSDictionary *params = @{@"password":_oldPsdField.text,@"newPassword":psdStr,@"newPasswordConfirm":psdConStr};
    [YYYHttpTool post:YYYUserPsdEditURL params:params success:^(id json) {
        
        if ([json[@"edited"] boolValue]) {
            UserInfo *userInfo = [UserInfoTool userInfo];
            userInfo.cookiePassword = json[@"userInfoValue"][@"cookiePassword"];
            [UserInfoTool saveUserInfo:userInfo];
            [WSProgressHUD showImage:nil status:@"密码修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [WSProgressHUD showImage:nil status:json[@"message"]];
        }
        
    } failure:^(NSError *error) {
        TSLog(@"UserPsdEditERROR:%@",error);
    }];
}

- (void)textFieldDidChange
{
    NSUInteger oldPsd = _oldPsdField.text.length;
    NSUInteger psdLen = _psdField.text.length;
    NSUInteger psdConLen = _psdFieldConfirm.text.length;
    if (oldPsd >= 6 && oldPsd <= 20 && psdLen >= 6 && psdLen <= 20 && psdConLen >= 6 && psdConLen <= 20)
    {
        _confirmBtn.backgroundColor = YYYMainColor;
        _confirmBtn.enabled = YES;
    } else {
        _confirmBtn.backgroundColor = YYYColor(200, 200, 200);
        _confirmBtn.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _oldPsdField ) {
        [_oldPsdField resignFirstResponder];
        [_psdField becomeFirstResponder];
    } else if (textField == _psdField) {
        [_psdField resignFirstResponder];
        [_psdFieldConfirm becomeFirstResponder];
    } else if (_confirmBtn.enabled) {
        [self psdEdit];
    }
    return YES;
}

- (UITextField *)oldPsdField
{
    if (!_oldPsdField) {
        _oldPsdField = [self setUpTextFieldWithFrame:CGRectMake(0, 50, kScreenWidth, 30) withLabelName:@"旧密码"];
        [_oldPsdField becomeFirstResponder];
    }
    return _oldPsdField;
}

- (UITextField *)psdField
{
    if (!_psdField) {
        _psdField = [self setUpTextFieldWithFrame:CGRectMake(0,120,kScreenWidth,30) withLabelName:@"新密码"];
    }
    return _psdField;
}

- (UITextField *)psdFieldConfirm
{
    if (!_psdFieldConfirm) {
        _psdFieldConfirm = [self setUpTextFieldWithFrame:CGRectMake(0,190,kScreenWidth,30) withLabelName:@"新密码确认"];
    }
    return _psdFieldConfirm;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake((kScreenWidth - 200) / 2, 250, 200, 50);
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _confirmBtn.titleLabel.backgroundColor = YYYColor(200,200,200);
        _confirmBtn.backgroundColor = YYYColor(200, 200, 200);
        _confirmBtn.enabled = NO;
        [_confirmBtn addTarget:self action:@selector(psdEdit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UITextField *)setUpTextFieldWithFrame:(CGRect)frame withLabelName:(NSString *)name
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,frame.origin.y - 30, 100, 20)];
    label.text = name;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:label];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleNone;
    textField.textAlignment = NSTextAlignmentLeft;
//    textField.font = [UIFont systemFontOfSize:14.0];
    textField.backgroundColor = [UIColor whiteColor];
    textField.delegate = self;
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textField setKeyboardType:UIKeyboardTypeDefault];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField setSecureTextEntry:YES];
    [textField setPlaceholder:@"请输入6~20位的密码"];
    [textField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    return textField;
}

@end

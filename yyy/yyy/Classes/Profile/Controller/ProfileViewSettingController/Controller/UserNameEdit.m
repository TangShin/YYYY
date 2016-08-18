//
//  UserNameEdit.m
//  yyy
//
//  Created by TangXing on 16/3/24.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "UserNameEdit.h"

@interface UserNameEdit () <UITextFieldDelegate>

@property (strong,nonatomic) UITextField *nameField;

@end

@implementation UserNameEdit

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YYYBackGroundColor;
    
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 40)];
    _nameField.borderStyle = UITextBorderStyleNone;
    _nameField.textAlignment = NSTextAlignmentLeft;
    _nameField.font = [UIFont systemFontOfSize:14.0];
    _nameField.backgroundColor = [UIColor whiteColor];
    [_nameField becomeFirstResponder];
    [_nameField setClearButtonMode:UITextFieldViewModeWhileEditing];
   [_nameField setReturnKeyType:UIReturnKeyDone];
    _nameField.text = _name;
    _nameField.delegate = self;
    
    [self.view addSubview:_nameField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self UserNameEditSuccess:textField.text];
    return YES;
}

- (void)UserNameEditSuccess:(NSString *)userName
{
    if (_delegate) {
        [_delegate UserNameEditSuccess:userName];
    }
}

@end

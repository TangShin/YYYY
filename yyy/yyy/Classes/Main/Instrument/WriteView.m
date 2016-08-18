//
//  WriteView.m
//  yyy
//
//  Created by TangXing on 16/4/19.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "WriteView.h"
#import "YYYLoginViewController.h"
#import "UserInfoTool.h"

@interface WriteView () <UITextViewDelegate>

@property (strong,nonatomic) UITextView *writeTextView;
@property (strong,nonatomic) UIButton *send;
@property (assign,nonatomic) CGFloat offset;
//动画持续时间
@property (assign,nonatomic) CGFloat duration;

@end

@implementation WriteView

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGRect frame = CGRectMake(0, kScreenHeight - 40 - 64, kScreenWidth, 40);
        [self setUpWriteView:frame];
    }
    return self;
}

- (void)setUpWriteView:(CGRect)frame
{
    self.frame = frame;
    self.backgroundColor = [UIColor whiteColor];
    
    //获取键盘的高度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //输入框
    self.writeTextView = [[UITextView alloc] initWithFrame:CGRectMake(10,5,frame.size.width - 70,30)];
    self.writeTextView.layer.cornerRadius = 4;
    self.writeTextView.layer.masksToBounds = YES;
    self.writeTextView.delegate = self;
    self.writeTextView.layer.borderWidth = 1;
    self.writeTextView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
    [self addSubview:self.writeTextView];
    
    //发送
    self.send = [UIButton buttonWithType:UIButtonTypeCustom];
    self.send.frame = CGRectMake(CGRectGetMaxX(self.writeTextView.frame) + 10, 5, 40, 30);
    [self.send setTitle:@"发送" forState:UIControlStateNormal];
    [self.send setTitleColor:YYYMainColor forState:UIControlStateNormal];
    self.send.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.send addTarget:self action:@selector(sendContent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.send];
}

#pragma mark send点击事件
- (void)sendContent
{
    if (_writeDelegate) {
        [_writeDelegate sendContent];
    }
}

#pragma mark - textview的代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{//将要开始编辑
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{//将要结束编辑
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{//开始编辑
    if (_writeDelegate) {
        [_writeDelegate returnWriteViewFrame:self.frame];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{//结束编辑
    
}

//return执行的方法
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (_writeDelegate) {
            [self sendContent];
        }
        return NO;
    }
    return YES;
}

#pragma mark 获取键盘高度
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfoDic = [aNotification userInfo];
    
    //动画持续时间
    self.duration = [userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //键盘的frame
    CGRect keyboardF = [userInfoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat minY = CGRectGetMinY(self.frame);
    self.offset = minY - keyboardF.size.height ;
    
    [UIView animateWithDuration:self.duration animations:^{
        [self setY:self.offset];
    }];
}

#pragma mark - 外部访问方法
- (void)hiddenKeyboard
{
    [self.writeTextView resignFirstResponder];
    [UIView animateWithDuration:self.duration animations:^{
        [self setY:kScreenHeight - 40 - 64];
    }];
}

- (NSString *)retuerTextViewText
{
    NSString *content = self.writeTextView.text;
    self.writeTextView.text = @"";
    return content;
}

- (void)setWriteViewKeyboardType:(YYYKeyboardType)writeViewKeyboardType
{
    [self.writeTextView setKeyboardType:(NSInteger)writeViewKeyboardType];
}

- (void)setWriteViewReturnKeyType:(YYYReturnKeyType)writeViewReturnKeyType
{
    [self.writeTextView setReturnKeyType:(NSInteger)writeViewReturnKeyType];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
@end

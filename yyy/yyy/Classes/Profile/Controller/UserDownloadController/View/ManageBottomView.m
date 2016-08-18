//
//  ManageBottomView.m
//  yyy
//
//  Created by TangXing on 16/3/28.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "ManageBottomView.h"

#define buttonWidth 100
#define buttonHeight 20

@interface ManageBottomView ()

@property (strong,nonatomic) UIButton *startBtn;
@property (strong,nonatomic) UIButton *pauseBtn;

@end

@implementation ManageBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self buildUIWithFrame:frame];
        
    }
    return self;
}

- (void)buildUIWithFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:[self deleteBtn]];
    [self addSubview:[self startBtn]];
    [self addSubview:[self pauseBtn]];
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [self setUpbutton:_deleteBtn buttonName:@"删除选中" action:@selector(deleteItem:)];
        _deleteBtn.frame = CGRectMake((kScreenWidth - buttonWidth) / 2, 10, buttonWidth, buttonHeight);
    }
    return _deleteBtn;
}

- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [self setUpbutton:_startBtn buttonName:@"全部开始" action:@selector(startItem:)];
        _startBtn.frame = CGRectMake(0, 10, buttonWidth, buttonHeight);
    }
    return _startBtn;
}

- (UIButton *)pauseBtn
{
    if (!_pauseBtn) {
        _pauseBtn = [self setUpbutton:_pauseBtn buttonName:@"全部暂停" action:@selector(pauseItem:)];
        _pauseBtn.frame = CGRectMake(kScreenWidth - buttonWidth, 10, buttonWidth, buttonHeight);
    }
    return _pauseBtn;
}

#pragma mark buttonClick
- (void)deleteItem:(UIButton *)sender
{
    if (_delegate) {
        [_delegate deleteItem:sender];
    }
}

- (void)startItem:(UIButton *)sender
{
    if (_delegate) {
        [_delegate startItem:sender];
    }
}

- (void)pauseItem:(UIButton *)sender
{
    if (_delegate) {
        [_delegate pauseItem:sender];
    }
}

- (void)Managemode:(NSInteger)mode
{
    if (mode == 0) {
        _startBtn.hidden = YES;
        _pauseBtn.hidden = YES;
    } else {
        _startBtn.hidden = NO;
        _pauseBtn.hidden = NO;
    }
    _deleteBtn.hidden = YES;
    _deleteBtn.enabled = NO;
    [_deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void)checkDeleteBtn:(NSString *)name enable:(BOOL)enable
{
    if (enable) {
        [_deleteBtn setTitle:name forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:YYYMainColor forState:UIControlStateNormal];
        _deleteBtn.enabled = enable;
    } else {
        [_deleteBtn setTitle:name forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _deleteBtn.enabled = enable;
    }
}

#pragma mark setUpbutton
- (UIButton *)setUpbutton:(UIButton *)button buttonName:(NSString *)name action:(SEL)action
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:YYYMainColor forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end

//
//  FourthViewController.m
//  yyy
//
//  Created by TangXing on 15/10/13.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "OtherViewController.h"

#import "PlaylistController.h"
#import "MVHomeViewController.h"

@implementation OtherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:YYYColor(246, 246, 246)];

    [self buildClassButton];
}

- (void)buildClassButton
{
    
    CGFloat buttonWidth = kScreenWidth/3;
    CGFloat buttonHeight = (kScreenHeight - 113)/4;
    
    for (int i = 0; i < 2; i++) {
        NSInteger index = i % 3;
        NSInteger page = i / 3;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setImage:[UIImage imageNamed:@"Untitled.png"] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        
        button.frame = CGRectMake(index * buttonWidth, page * buttonHeight, buttonWidth, buttonHeight);
        
        [button addTarget:self action:@selector(orgVC:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

- (void)orgVC:(UIButton *)button
{
    if (button.tag == 0) {
        
        PlaylistController *playlistView = [[PlaylistController alloc] init];
        [self.navigationController pushViewController:playlistView animated:YES];
        
    } else if (button.tag == 1) {
        
        MVHomeViewController *MVHomeView = [[MVHomeViewController alloc] init];
        [self.navigationController pushViewController:MVHomeView animated:YES];
        
    }
}

@end

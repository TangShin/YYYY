//
//  PlaylistHomeViewController.m
//  yyy
//
//  Created by TangXing on 16/2/15.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "PlaylistHomeViewController.h"

@interface PlaylistHomeViewController ()

@end

@implementation PlaylistHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:YYYRandomColor];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TScell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TSCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

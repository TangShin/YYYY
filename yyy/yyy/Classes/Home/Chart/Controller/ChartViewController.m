//
//  SecondViewController.m
//  yyy
//
//  Created by TangXing on 15/10/13.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "ChartViewController.h"

@implementation ChartViewController

- (void)viewDidLoad
{
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

@end

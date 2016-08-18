//
//  AboutYYYView.m
//  yyy
//
//  Created by TangXing on 16/4/5.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "AboutYYYView.h"

@interface AboutYYYView ()

@property (strong,nonatomic) NSArray *versionArray;
@property (strong,nonatomic) NSArray *otherArray;

@end

@implementation AboutYYYView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _versionArray = @[@"当前版本",@"新版更新"];
    _otherArray = @[@"关于『壹音乐客户端』",@"反馈问题或建议",@"给我们评分"];
}

#pragma mark tableViewDelegate
//设置每个分组下tableview的分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//设置每个分组下tableview的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _versionArray.count;
    } else {
        return _otherArray.count;
    }
}

//设置headerview显示内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor clearColor];
        
        UIImageView *LogoImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 50)/2,20,50,50)];
        LogoImage.image = [UIImage imageNamed:@"appicon60x60"];
        
        [headerView addSubview:LogoImage];
        return headerView;
    }
    return nil;
}

//设置fotterview显示内容
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor clearColor];
        footerView.userInteractionEnabled = YES;
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 30)];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.font = [UIFont systemFontOfSize:12.0];
        infoLabel.textColor = YYYColor(150, 150, 150);
        infoLabel.numberOfLines = 0;
        infoLabel.text = @"使用壹音乐网页版,电脑客户端,手机客户端,多端同步,视频随身看!请访问:yyinyue.com";
        
        UIButton *provision = [UIButton buttonWithType:UIButtonTypeCustom];
        [provision setTitle:@"《壹音乐服务条款》" forState:UIControlStateNormal];
        [provision setTitleColor:YYYMainColor forState:UIControlStateNormal];
        [provision setFrame:CGRectMake((kScreenWidth - 110)/2, 100, 110, 20)];
        [provision setBackgroundColor:[UIColor clearColor]];
        [provision addTarget:self action:@selector(provisionTarget:) forControlEvents:UIControlEventTouchUpInside];
        provision.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        [footerView addSubview:infoLabel];
        [footerView addSubview:provision];
        return footerView;
    }
    return nil;
}

//每个分组上边预留空白高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 90;
    }
    return 10;
}

//每个分组下边预留空白高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 160;
}

//每一个分组下对应的tableviewCell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    //UITableViewAutomaticDimension 设置高度自动获取
}

//初始加载tableviewcell时，给出预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

//设置每行对应的cell(展示的内容)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"aboutCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    versionLabel.font = [UIFont systemFontOfSize:14.0];
    versionLabel.textColor = [UIColor grayColor];
    versionLabel.textAlignment = NSTextAlignmentRight;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = _versionArray[indexPath.row];
        versionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.accessoryView = versionLabel;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        
        cell.textLabel.text = _versionArray[indexPath.row];
        NSString *newAppVersion = @"2";
        NSString *appbuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        if ([newAppVersion isEqualToString:appbuild]) {
            versionLabel.text = @"无新版";
        } else {
            versionLabel.text = @"有新版";
        }
        cell.accessoryView = versionLabel;
    } else {
        cell.textLabel.text = _otherArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //取消cell选中状态
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)provisionTarget:(UIButton *)sender
{
    TSLog(@"hello");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

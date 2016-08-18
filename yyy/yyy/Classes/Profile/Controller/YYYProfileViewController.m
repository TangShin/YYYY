//
//  YYYProfileViewController.m
//  
//
//  Created by TangXing on 15/10/10.
//
//

#import "YYYProfileViewController.h"
#import "YYYLoginViewController.h"

#import "ProfileView.h"
#import "UserNoticeView.h"
#import "UserMessageView.h"
#import "DownloadManageView.h"
#import "VideoHistoryView.h"
#import "UserFavoriteView.h"
#import "UserFollowView.h"
#import "SettingTableView.h"
#import "AboutYYYView.h"

#import "ProfileViewCell.h"

#import "YYYHttpTool.h"
#import "UserInfoTool.h"

@interface YYYProfileViewController ()

@property (strong,nonatomic) NSArray *myNotice;
@property (strong,nonatomic) NSArray *dataSource;
@property (strong,nonatomic) NSArray *aboutApp;
@property (strong,nonatomic) UserInfo *userInfo;//用户信息


@property (assign,nonatomic) NSInteger unreadNoticeCount;
@property (assign,nonatomic) NSInteger unreadMessageCount;

@end

@implementation YYYProfileViewController

- (NSArray *)myNotice
{
    if (!_myNotice) {
        self.myNotice = @[@"我的消息",@"我的留言"];
    }
    return _myNotice;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        self.dataSource = @[@"下载管理",@"历史记录",@"我的收藏",@"我的关注"];
    }
    return _dataSource;
}

- (NSArray *)aboutApp
{
    if (!_aboutApp) {
        self.aboutApp = @[@"设置",@"关于"];
    }
    return _aboutApp;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.showsVerticalScrollIndicator = NO;//不显示右滑块
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
//    [self loadData];
}

- (void)loadData
{
    [YYYHttpTool post:YYYUserHomeView params:nil success:^(id json) {
        self.unreadNoticeCount = [json[@"unreadNoticeCount"] integerValue];
        self.unreadMessageCount = [json[@"unreadMessageCount"] integerValue];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        TSLog(@"ProfileViewERROR %@",error);
    }];
}


#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //分组数
    return 4;
}

//设置每个分组下tableview的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.myNotice.count;
    } else if (section == 2){
        return self.dataSource.count;
    } else {
        return self.aboutApp.count;
    }
}

//每个分组上边预留空白高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 5;
}

//每个分组下边预留空白高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

//每一个分组下对应的tableviewCell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    return 40;
}

//设置每行对应的cell(展示的内容)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取用户信息
    UserInfo *userInfo = [UserInfoTool userInfo];
    self.userInfo = userInfo;
    
    UINib *profileNib = [UINib nibWithNibName:@"ProfileViewCell" bundle:nil];
    [tableView registerNib:profileNib forCellReuseIdentifier:@"profileCell"];
    
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    ProfileViewCell *Pcell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
    Pcell.selectionStyle = UITableViewCellSelectionStyleNone;
    Pcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        //清空cell的contentview下的所有子view
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        if (self.userInfo.userName != nil) {
            //创建头像
            UIImageView *userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 70, 70)];
            userPhoto.image = self.userInfo.userPhoto;
            userPhoto.layer.masksToBounds = YES;
            userPhoto.layer.cornerRadius = userPhoto.bounds.size.width * 0.5;
            [cell.contentView addSubview:userPhoto];
            //创建名字
            UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, kScreenWidth - 100, 80)];
            userName.text = self.userInfo.userName;
            [cell.contentView addSubview:userName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        } else {
            //创建注册按钮
            UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            registBtn.frame = CGRectMake((kScreenWidth - 250) / 2, 20, 120, 40);
            [registBtn setTitle:@"注册" forState:UIControlStateNormal];
            [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [registBtn setBackgroundColor:YYYColor(255, 102, 153)];
            [registBtn addTarget:self action:@selector(registbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            //创建登陆按钮
            UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            loginBtn.frame = CGRectMake(CGRectGetMaxX(registBtn.frame) + 10, 20, 120, 40);
            [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginBtn setBackgroundColor:YYYColor(255, 102, 153)];
            [loginBtn addTarget:self action:@selector(loginbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:registBtn];
            [cell.contentView addSubview:loginBtn];
            //未登陆状态，section=0的cell不能被点击
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    } else if (indexPath.section == 1) {
        
        Pcell.image.image = [UIImage imageNamed:@"my_msg"];
        Pcell.title.text = self.myNotice[indexPath.row];
        
        if (self.unreadNoticeCount > 0 && indexPath.row == 0) {
            [Pcell.NewNotice setCurrentPageIndicatorTintColor:YYYMainColor];
        }
        if (self.unreadMessageCount > 0 && indexPath.row == 1) {
            [Pcell.NewNotice setCurrentPageIndicatorTintColor:YYYMainColor];
        }
        
        return Pcell;
        
    } else if (indexPath.section == 3) {
        NSString *imageName = [NSString stringWithFormat:@"about_%ld",(long)indexPath.row];
        Pcell.image.image = [UIImage imageNamed:imageName];
        Pcell.title.text = self.aboutApp[indexPath.row];
        return Pcell;
    } else {
        NSString *imageName = [NSString stringWithFormat:@"profile_%ld",(long)indexPath.row];
        Pcell.image.image = [UIImage imageNamed:imageName];
        Pcell.title.text = self.dataSource[indexPath.row];
        return Pcell;
    }
    
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.userInfo.userName != nil && indexPath.section == 0) {
        //进入个人信息页面
        ProfileView *profile = [[ProfileView alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:profile animated:YES];
    }
    
    if (indexPath.row == 0 && indexPath.section == 1) {
        UserNoticeView *userNoticeView = [[UserNoticeView alloc] initWithStyle:UITableViewStylePlain];
        userNoticeView.title = self.myNotice[indexPath.row];
        [self.navigationController pushViewController:userNoticeView animated:YES];
    }
    
    if (indexPath.row == 1 && indexPath.section == 1) {
        UserMessageView *userMessageView = [[UserMessageView alloc] initWithStyle:UITableViewStylePlain];
        userMessageView.title = self.myNotice[indexPath.row];
        [self.navigationController pushViewController:userMessageView animated:YES];
    }
    
    if (indexPath.row == 0 && indexPath.section == 2) {
        DownloadManageView *downloadMagage = [[DownloadManageView downloadManager] init];
        [self.navigationController pushViewController:downloadMagage animated:YES];
    }
    
    if (indexPath.row == 1 && indexPath.section == 2) {
        VideoHistoryView *videoHistoryView = [[VideoHistoryView alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:videoHistoryView animated:YES];
    }
    
    if (indexPath.row == 2 && indexPath.section == 2) {
        UserFavoriteView *userFavoriteView = [[UserFavoriteView alloc] init];
        [self.navigationController pushViewController:userFavoriteView animated:YES];
    }
    
    if (indexPath.row == 3 && indexPath.section == 2) {
        UserFollowView *userFollowView = [[UserFollowView alloc] initWithStyle:UITableViewStylePlain];
        userFollowView.title = _dataSource[indexPath.row];
        [self.navigationController pushViewController:userFollowView animated:YES];
    }
    
    if (indexPath.row == 0 && indexPath.section == 3) {
        SettingTableView *settingView = [[SettingTableView alloc] initWithStyle:UITableViewStyleGrouped];
        settingView.title = self.aboutApp[indexPath.row];
        [self.navigationController pushViewController:settingView animated:YES];
    }
    
    if (indexPath.row == 1 && indexPath.section == 3) {
        AboutYYYView *aboutYYYView = [[AboutYYYView alloc] initWithStyle:UITableViewStyleGrouped];
        aboutYYYView.title = self.aboutApp[indexPath.row];
        [self.navigationController pushViewController:aboutYYYView animated:YES];
    }
}

- (void)loginbuttonClick:(UIButton *)sender
{
    //进入登陆界面
    YYYLoginViewController *loginVC = [[YYYLoginViewController alloc] init];
    loginVC.registState = NO;
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)registbuttonClick:(UIButton *)sender
{
    //进入注册界面
    YYYLoginViewController *loginVC = [[YYYLoginViewController alloc] init];
    loginVC.registState = YES;
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    //退出登陆，返回时刷新此界面
    [self.tableView reloadData];
}

@end

//
//  YYYTabBarController.m
//  
//
//  Created by TangXing on 15/10/10.
//
//

#import "YYYTabBarController.h"
#import "YYYHomeViewController.h"
#import "YYYMicroVideoViewController.h"
#import "YYYDiscoverViewController.h"
#import "YYYProfileViewController.h"
#import "YYYNavigationController.h"

#import "ProfileViewTool.h"

@interface YYYTabBarController ()

@property (strong,nonatomic) UserSetting *userSetting;
@property (assign,nonatomic) BOOL sendErrorLog;

@end

@implementation YYYTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _userSetting = [ProfileViewTool userSetting];
    //第一次启动设置用户配置
    if (!_userSetting) {
        [self firstLaunchApp];
    }
    //检测是否有错误日志,如果有,则上传
    if (_userSetting.sendErrorLog) {
        BOOL isHave = [self sendErrorLogFromApp];
        if (isHave) {
            TSLog(@"有错误日志");
        }
    }
    
    YYYHomeViewController *home = [[YYYHomeViewController alloc] init];
    [self addchildVc:home tittle:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    YYYDiscoverViewController *discover = [[YYYDiscoverViewController alloc] init];
    [self addchildVc:discover tittle:@"搜索" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    YYYMicroVideoViewController *myVideo = [[YYYMicroVideoViewController alloc] init];
    [self addchildVc:myVideo tittle:@"微拍" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    YYYProfileViewController *profile = [[YYYProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self addchildVc:profile tittle:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
}

- (void)addchildVc:(UIViewController *)childVc tittle:(NSString *)tittle image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = tittle;
    
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    //声明图片按照原始的样子显示 不要自动渲染成其它颜色-- imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *textAttrs =[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = YYYColor(123, 123, 123);
    NSMutableDictionary *selectedtextAttrs = [NSMutableDictionary dictionary];
    selectedtextAttrs[NSForegroundColorAttributeName] = YYYMainColor;
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectedtextAttrs forState:UIControlStateSelected];
    
    YYYNavigationController *nav = [[YYYNavigationController alloc] initWithRootViewController:childVc];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbg.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self addChildViewController:nav];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)firstLaunchApp
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"您愿意帮助我们完善APP吗?" delegate:self cancelButtonTitle:@"嫌弃" otherButtonTitles:@"当然！", nil];
    [logoutAlert show];
}

- (BOOL)sendErrorLogFromApp
{
    //文件名
    NSString *fileName = [NSString stringWithFormat:@"error.log"];
    NSString *uniquePath=[DocumentsDirectory stringByAppendingPathComponent:fileName];
    BOOL isHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    return isHave;
}

#pragma mark -AlertView监听方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        _sendErrorLog = NO;
    } else {
        _sendErrorLog = YES;
    }
    
    NSDictionary *settingDic = @{@"autoPlay":[NSNumber numberWithBool:NO],@"autoFullScreenPlay":[NSNumber numberWithBool:NO],@"netWorkSatePlay":[NSNumber numberWithBool:NO],@"netWorkSateDownload":[NSNumber numberWithBool:NO],@"sendErrorLog":[NSNumber numberWithBool:_sendErrorLog]};
    
    _userSetting = [UserSetting UserSettingWithDic:settingDic];
    [ProfileViewTool saveUserSetting:_userSetting];
}
@end

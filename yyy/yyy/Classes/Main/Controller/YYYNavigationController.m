//
//  YYYNavigationController.m
//  
//
//  Created by TangXing on 15/10/10.
//
//

#import "YYYNavigationController.h"

@implementation YYYNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    /*
     第一次进来的时候，viewControllers.count为0，所以if不执行，但根控制器已经有了
     下面的代码push一个界面后，viewControllers.count为1，所以if执行
     所以往后的控制器都能设置左右上角的Item和隐藏下方的tabbar
     */
    if (self.viewControllers.count > 0) {
        
        //隐藏根控制器之外的控制器下发的TabBarController
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end

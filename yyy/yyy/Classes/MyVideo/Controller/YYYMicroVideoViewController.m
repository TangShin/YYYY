//
//  YYYMicroVideoViewController.m
//  
//
//  Created by TangXing on 15/10/10.
//
//

#import "YYYMicroVideoViewController.h"
#import "YYYSandboxHelper.h"

@implementation YYYMicroVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YYYMainColor;
    
    TSLog(@"%@",[YYYSandboxHelper docPath]);
}
@end

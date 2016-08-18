//
//  SubMediaView.h
//  yyy
//
//  Created by TangXing on 16/5/12.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MediaFrame;

@interface SubMediaView : UITableViewController

@property (strong,nonatomic) MediaFrame *mediaF;
@property (copy, nonatomic) NSString *userId;

@end

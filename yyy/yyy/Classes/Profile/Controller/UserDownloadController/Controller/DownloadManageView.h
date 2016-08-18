//
//  DownloadManageView.h
//  yyy
//
//  Created by TangXing on 16/3/16.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DownloadManageViewDelegate <NSObject>

- (void)downloadSuccess;

@end

@interface DownloadManageView : UIViewController

@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) NSString *imgUrl;

@property (nonatomic,assign)id <DownloadManageViewDelegate> delegate;

+ (DownloadManageView *)downloadManager;

- (void)downloadImage:(NSDictionary *)dictionary newItem:(BOOL)isNew;
- (void)addDownloadingItem:(NSDictionary *)dict;


@end

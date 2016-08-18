//
//  SubCommentView.h
//  yyy
//
//  Created by TangXing on 15/12/14.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubCommentView : UIViewController <UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSString *timestamp;
@property (strong,nonatomic) NSString *videoId;
@property (strong,nonatomic) NSString *pageButton;
@property (strong,nonatomic) NSString *page;
@property (assign,nonatomic) NSInteger mediaIndex;

@property (strong,nonatomic) NSDictionary *selectedMedia;

@end

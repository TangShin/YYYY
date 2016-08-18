//
//  UserNoticeModel.h
//  yyy
//
//  Created by TangXing on 16/4/13.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserNoticeModel : NSObject

@property (copy,nonatomic) NSString *userId;
@property (copy,nonatomic) NSString *userName;
@property (copy,nonatomic) NSString *userPhoto;
@property (copy,nonatomic) NSString *previewMessage;
@property (copy,nonatomic) NSString *lastestMessageDate;
@property (copy,nonatomic) NSString *unreadMessageCount;
@property (copy,nonatomic) NSString *noticeDiv;

@end

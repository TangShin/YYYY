//
//  UserInfo.h
//  yyy
//
//  Created by TangXing on 15/11/12.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject <NSCoding>

/**　string	用户头像*/
@property (nonatomic, copy) UIImage *userPhoto;

/**　string	用户名称。*/
@property (nonatomic, copy) NSString *userName;

/** string 用户id */
@property (nonatomic, copy) NSString *userId;

/** cookiePassword */
@property (nonatomic, copy) NSString *cookiePassword;

+ (instancetype)userInfoWithDict:(NSDictionary *)dict;

@end

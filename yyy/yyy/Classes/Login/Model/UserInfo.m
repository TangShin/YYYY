//
//  UserInfo.m
//  yyy
//
//  Created by TangXing on 15/11/12.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "UserInfo.h"
#import "MJExtension.h"

@implementation UserInfo
+ (instancetype)userInfoWithDict:(NSDictionary *)dict
{
    UserInfo *userInfo = [[self alloc] init];

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"userPhoto"]]];
    userInfo.userPhoto = [UIImage imageWithData:data];
    userInfo.userId = dict[@"userId"];
    userInfo.userName = dict[@"userName"];
    userInfo.cookiePassword = dict[@"cookiePassword"];
    return userInfo;
}

/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userPhoto forKey:@"userPhoto"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:self.cookiePassword forKey:@"cookiePassword"];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.userPhoto = [decoder decodeObjectForKey:@"userPhoto"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.userName = [decoder decodeObjectForKey:@"userName"];
        self.cookiePassword = [decoder decodeObjectForKey:@"cookiePassword"];
    }
    
    return self;
}

@end

//
//  YYYHttpTool.m
//  yyy
//
//  Created by TangXing on 15/11/12.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "YYYHttpTool.h"
#import "AFNetworking.h"
#import "JSESSIONIDTool.h"
#import "UserInfoTool.h"

@implementation YYYHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [manger GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger.operationQueue cancelAllOperations];
    
    // 2. 设置请求头信息
    JSESSIONID *jsessionIdDecoder = [JSESSIONIDTool jsessionId];
    UserInfo *userInfo = [UserInfoTool userInfo];
    NSString *cookieStr = @"";
    
    if (jsessionIdDecoder.JSESSIONID != nil) {
        cookieStr = [NSString stringWithFormat:@"JSESSIONID=%@",jsessionIdDecoder.JSESSIONID];
    }
    if (userInfo.userId != nil) {
        if (cookieStr.length > 0) {
            cookieStr = [NSString stringWithFormat:@"%@;",cookieStr];
        }
        cookieStr = [NSString stringWithFormat:@"%@yiyinyue.cookie=%@,%@",cookieStr,userInfo.userId,userInfo.cookiePassword];
    }
    if (cookieStr.length > 0) {
        [manger.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    }
    
    // 3.发送请求
    [manger POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            //保存jsessionId
            JSESSIONID *jsessionIdEncoder = [JSESSIONID JSESSIONIDWithDict:operation.response.allHeaderFields];
            
            if (jsessionIdEncoder.JSESSIONID != nil) {
                [JSESSIONIDTool saveJsessionId:jsessionIdEncoder];
            }
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end

//
//  YYYHttpTool.h
//  yyy
//
//  Created by TangXing on 15/11/12.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYYHttpTool : NSObject
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end

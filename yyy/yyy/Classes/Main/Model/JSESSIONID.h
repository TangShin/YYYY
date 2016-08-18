//
//  JSESSIONID.h
//  yyy
//
//  Created by TangXing on 15/11/23.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSESSIONID : NSObject<NSCoding>

/** JSESSIONID */
@property (nonatomic, copy) NSString *JSESSIONID;

+ (instancetype)JSESSIONIDWithDict:(NSDictionary *)dict;

@end

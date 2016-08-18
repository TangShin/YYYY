//
//  JSESSIONID.m
//  yyy
//
//  Created by TangXing on 15/11/23.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "JSESSIONID.h"

#define sessionIdName @"JSESSIONID"

@implementation JSESSIONID

+ (instancetype)JSESSIONIDWithDict:(NSDictionary *)dict
{
    JSESSIONID *jsessionId = [[self alloc] init];
    
    jsessionId.JSESSIONID = dict[sessionIdName];
    
    return jsessionId;
}

/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.JSESSIONID forKey:sessionIdName];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.JSESSIONID = [decoder decodeObjectForKey:sessionIdName];
    }
    
    return self;
}

@end

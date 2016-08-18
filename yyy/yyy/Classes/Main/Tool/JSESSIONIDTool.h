//
//  JSESSIONID.h
//  yyy
//
//  Created by TangXing on 15/11/23.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSESSIONID.h"

@interface JSESSIONIDTool : NSObject

/**
 *  存储JSESSIONID
 *
 *  @param JSESSIONID JSESSIONID模型
 */
+ (void)saveJsessionId:(JSESSIONID *)jsessionId;

/**
 *  返回JSESSIONID
 *
 *  @return JSESSIONID
 */
+ (JSESSIONID *)jsessionId;

@end

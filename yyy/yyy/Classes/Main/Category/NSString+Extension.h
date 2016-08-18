//
//  NSString+Extension.h
//  yyy
//
//  Created by TangXing on 15/12/1.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigAttributedString.h"

@interface NSString (Extension)

#pragma mark - CalTextSize
//根据文字字体计算size，最大宽度限制
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
//根据文字字体计算size，最大宽度无限制
- (CGSize)sizeWithFont:(UIFont *)font;
//计算单行文本size
- (CGSize)singleLinesTextSizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

#pragma mark - NSStringToNSDate
//NSString转NSDate
- (NSDate *)stringToDate:(NSString *)stringDate;

#pragma mark - CalTimeDifference
/**
 1.今年
 1> 今天
 * 1分内： 刚刚
 * 1分~59分内：xx分钟前
 * 大于60分钟：xx小时前
 
 2> 昨天
 * 昨天 xx:xx
 
 3> 其他
 * xx-xx xx:xx
 
 2.非今年
 1> xxxx-xx-xx xx:xx
 */
- (NSString *)creatTime;

/** 创建聊天时间 */
- (NSString *)creatLetterTime;

/** 创建留言时间 */
- (NSString *)creatMediaTime;

#pragma mark - RichText
// 创建富文本并配置富文本(NSArray中的数据必须是ConfigAttributedString对象合集)
- (NSMutableAttributedString *)createAttributedStringAndConfig:(NSArray *)configs;

// 用于搜寻一段字符串在另外一段字符串中的NSRange值
- (NSRange)rangeFrom:(NSString *)string;

// 本字符串的range
- (NSRange)range;
@end

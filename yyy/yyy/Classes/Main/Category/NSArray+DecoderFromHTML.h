//
//  NSArray+DecoderFromHTML.h
//  yyy
//
//  Created by TangXing on 16/4/14.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DecoderFromHTML)

/**
 *  评论、信息数据的解码，把数组变为string
 *
 *  @param array    数据源数组
 *
 *  @return 返回字符串
 */
- (NSString *)decodeFromHTML:(NSArray *)array;

/**
 *  将json数据里的字符串数组转换成ios字符串,返回新生成的数据数组,便于模型解析
 *
 *  @param array  数据源数组
 *  @param key    键
 *
 *  @return 返回字符串
 */
//- (NSArray *)creatModelArrayFromArray:(NSArray *)array withDictionaryKey:(NSString *)key;
- (NSArray *)creatModelArrayWithDictionaryKey:(NSString *)key;

@end

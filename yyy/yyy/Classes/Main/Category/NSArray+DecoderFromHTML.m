//
//  NSArray+DecoderFromHTML.m
//  yyy
//
//  Created by TangXing on 16/4/14.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "NSArray+DecoderFromHTML.h"

@implementation NSArray (DecoderFromHTML)

- (NSString *)decodeFromHTML:(NSArray *)array
{
    NSString *coment = [array componentsJoinedByString:@"\n"];
    
    coment = [coment stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    coment = [coment stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    coment = [coment stringByReplacingOccurrencesOfString:@"&#92;" withString:@"\\"];
    
    return coment;
}

//评论为数组，转成nsstring
//- (NSArray *)creatModelArrayFromArray:(NSArray *)array withDictionaryKey:(NSString *)key
- (NSArray *)creatModelArrayWithDictionaryKey:(NSString *)key
{
    if (self.count == 0) {
        return nil;
    }
    NSMutableArray *newArray = [NSMutableArray array];
    
    for (int i = 0; i <self.count ; i++) {
        
        NSMutableDictionary *dict = [self[i] mutableCopy];
        NSArray *stringArray = dict[key];
        NSString *string;
        
        if (stringArray.count > 0) {
            string = [stringArray decodeFromHTML:stringArray];
        }
        
        [dict setObject:string forKey:key];
        
        [newArray addObject:dict];
    }
    return newArray;
}

@end

//
//  UserLetterModel.h
//  yyy
//
//  Created by TangXing on 16/4/15.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLetterModel : NSObject

@property (copy,nonatomic) NSString *userId;
@property (copy,nonatomic) NSString *sendTime;
@property (copy,nonatomic) NSString *content;
@property (copy,nonatomic) NSString *otherSideUserName;
@property (copy,nonatomic) NSString *otherSideUserPhoto;
@property (assign,nonatomic) BOOL timehidden;

@end

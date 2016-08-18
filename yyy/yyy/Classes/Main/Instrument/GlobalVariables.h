//
//  GlobalVariables.h
//  yyy
//
//  Created by TangXing on 16/4/8.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVariables : NSObject

@property (assign,nonatomic) BOOL downloading;                  //是否正在下载
@property (assign,nonatomic) NSInteger  downloadingCellIndex;   //正在下载的cell的索引

+ (GlobalVariables *)getInstance;

@end

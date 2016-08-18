//
//  UserNameEdit.h
//  yyy
//
//  Created by TangXing on 16/3/24.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserNameEditDelegate <NSObject>

- (void)UserNameEditSuccess:(NSString *)userName;

@end

@interface UserNameEdit : UIViewController

@property (copy,nonatomic) NSString *name;

@property (nonatomic,assign)id <UserNameEditDelegate> delegate;

@end

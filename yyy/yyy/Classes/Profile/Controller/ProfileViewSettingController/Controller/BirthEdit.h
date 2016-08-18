//
//  BirthEdit.h
//  yyy
//
//  Created by TangXing on 16/3/24.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BirthdayDelegate <NSObject>

- (void)dateChange:(id)sender;

@end

@interface BirthEdit : UIViewController

@property (copy,nonatomic) NSString *birthday;

@property (strong,nonatomic) id <BirthdayDelegate> delegate;

@end

//
//  ManageBottomView.h
//  yyy
//
//  Created by TangXing on 16/3/28.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ManageBottomDelegate <NSObject>

- (void)deleteItem:(UIButton *)sender;
- (void)startItem:(UIButton *)sender;
- (void)pauseItem:(UIButton *)sender;

@end

@interface ManageBottomView : UIView

@property (strong,nonatomic) UIButton *deleteBtn;
@property (strong,nonatomic) id <ManageBottomDelegate> delegate;

- (void)Managemode:(NSInteger)mode;
- (void)checkDeleteBtn:(NSString *)name enable:(BOOL)enable;

@end

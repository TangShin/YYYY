//
//  NoNetworkView.h
//  yyy
//
//  Created by TangXing on 16/5/6.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoNetworkViewDelegate <NSObject>

- (void)NoNetworkViewClick;

@end

@interface NoNetworkView : UIView

@property (assign,nonatomic) id <NoNetworkViewDelegate> noNetworkDelegate;

@end

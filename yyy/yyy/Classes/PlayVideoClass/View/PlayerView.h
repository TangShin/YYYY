//
//  PlayerView.h
//  yyy
//
//  Created by TangXing on 15/11/3.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerView : UIView

@property (nonatomic,strong) AVPlayer *player;

-(void)setFillMode:(NSString *)fillMode;

@end

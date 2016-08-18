//
//  PlayerView.m
//  yyy
//
//  Created by TangXing on 15/11/3.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//
//-----------------显示视频的view-----------------------

#import "PlayerView.h"

@implementation PlayerView

+(Class)layerClass
{
    return [AVPlayerLayer class];
}

-(AVPlayer *)player
{
    return [(AVPlayerLayer *)self.layer player];
}

-(void)setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *)self.layer setPlayer:player];
}

-(void)setFillMode:(NSString *)fillMode
{
    [(AVPlayerLayer *)self.layer setVideoGravity:fillMode];
}

@end

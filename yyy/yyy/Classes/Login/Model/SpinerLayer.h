//
//  SpinerLayer.h
//  yyy
//
//  Created by TangXing on 15/10/28.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface SpinerLayer : CAShapeLayer

-(instancetype) initWithFrame:(CGRect)frame;

-(void)animation;

-(void)stopAnimation;

@end

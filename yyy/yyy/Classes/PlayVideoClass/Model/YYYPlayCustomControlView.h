//
//  YYYPlayCustomControlView.h
//  yyy
//
//  Created by TangXing on 15/11/3.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYPlayCustomControlView : UIView

@property (weak, nonatomic) IBOutlet UIButton *loopButton;

@property (nonatomic,assign) CGFloat videoDuration;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL isControlEnable;

-(void)showWithClickHandle:(void (^)(NSInteger tag))clickHandle slideHandle:(void (^)(CGFloat interval,BOOL isFinished))slideHandle;

-(void)setSlideValue:(CGFloat)value;

@end

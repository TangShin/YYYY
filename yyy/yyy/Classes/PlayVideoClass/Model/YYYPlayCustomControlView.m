//
//  YYYPlayCustomControlView.m
//  yyy
//
//  Created by TangXing on 15/11/3.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//
//-----------------自定义工具栏（播放，进度条等）-----------------------

#import "YYYPlayCustomControlView.h"

#define kBaseTag 1000
#define kSliderSize CGSizeMake(15, 15)

@interface YYYPlayCustomControlView ()

//@property (weak, nonatomic) IBOutlet UIButton *playParseBtn;

@property (weak, nonatomic) IBOutlet UIButton *fullscreenBtn;
@property (weak, nonatomic) IBOutlet UISlider *progress;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,assign) CGFloat currentTime;

@property (nonatomic,copy) void (^clickHandle)(NSInteger);
@property (nonatomic,copy) void (^slideHandle)(CGFloat,BOOL);

@end

@implementation YYYPlayCustomControlView
//加载xib
-(void)awakeFromNib
{
    [super awakeFromNib];
    
//    [_playParseBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_playParseBtn setTag:kBaseTag + 1];
    [_loopButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_loopButton setTag:kBaseTag + 1];
    [_fullscreenBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_fullscreenBtn setTag:kBaseTag + 2];
    
    [_progress setValue:0];
    [_progress setTintColor:[UIColor redColor]];
    [_progress addTarget:self action:@selector(slideAction:) forControlEvents:UIControlEventValueChanged];
    [_progress addTarget:self action:@selector(moveEndAction:) forControlEvents:UIControlEventTouchUpInside];
    [_progress setThumbImage:[self scaleImageSize:kSliderSize imageName:@"sliderThumb"] forState:UIControlStateHighlighted];
    [_progress setThumbImage:[self scaleImageSize:kSliderSize imageName:@"sliderThumb"] forState:UIControlStateNormal];
    [_progress setTag:kBaseTag + 3];
    [_currentTimeLabel setTextColor:[UIColor whiteColor]];
    [_currentTimeLabel setTextAlignment:NSTextAlignmentRight];
    [_timeLabel setTextColor:[UIColor whiteColor]];
    [_timeLabel setTextAlignment:NSTextAlignmentRight];
    
    self.isControlEnable = NO;
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    self.backgroundColor = [UIColor clearColor];
}

- (UIImage *)scaleImageSize:(CGSize)size imageName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaleImage;
}

//设置视频时长
-(void)setVideoDuration:(CGFloat)videoDuration
{
    _videoDuration = videoDuration;
    
    [self updateProgressText];
}

-(void)setIsControlEnable:(BOOL)isControlEnable
{
    _isControlEnable = isControlEnable;
    
//    [_playParseBtn setEnabled:_isControlEnable];
    [_fullscreenBtn setEnabled:_isControlEnable];
    [_progress setEnabled:_isControlEnable];
}

-(void)setCurrentTime:(CGFloat)currentTime
{
    if(_currentTime != currentTime)
    {
        _currentTime = currentTime;
        
        [self updateProgressText];
    }
}

-(void)setSlideValue:(CGFloat)value
{
    [_progress setValue:value animated:YES];
    
    self.currentTime = value * _videoDuration;
}

//视频进度条
-(void)updateProgressText
{
    _currentTimeLabel.text = [NSString stringWithFormat:@"%@",[self getTimeString:_currentTime]];
    _timeLabel.text = [NSString stringWithFormat:@"%@",[self getTimeString:_videoDuration]];
}

-(NSString *)getTimeString:(CGFloat)timeInterval
{
    NSInteger hour = timeInterval / 3600.f;
    NSInteger minute = (timeInterval - hour * 3600.f) / 60.f;
    NSInteger second = timeInterval - hour * 3600.f - minute * 60.f;
    
    if(hour > 0)
    {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld",(long)hour,(long)minute,(long)second];
    }
    else
    {
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)minute,(long)second];
    }
}

-(void)buttonAction:(UIButton *)sender
{
    NSInteger tag = sender.tag - kBaseTag;
    
    if(_clickHandle)
    {
        _clickHandle (tag);
    }
}

-(void)slideAction:(UISlider *)slider
{
    CGFloat progress = slider.value;
    
    CGFloat interval = progress * _videoDuration;
    self.currentTime = interval;
    
    if(_slideHandle)
    {
        _slideHandle(_currentTime,NO);
    }
}

-(void)moveEndAction:(UISlider *)slider
{
    CGFloat progress = slider.value;

    CGFloat interval = progress * _videoDuration;
    self.currentTime = interval;
    
    if(_slideHandle)
    {
        _slideHandle(_currentTime,YES);
    }
}

-(void)showWithClickHandle:(void (^)(NSInteger))clickHandle slideHandle:(void (^)(CGFloat,BOOL))slideHandle
{
    self.clickHandle = clickHandle;
    self.slideHandle = slideHandle;
}

@end

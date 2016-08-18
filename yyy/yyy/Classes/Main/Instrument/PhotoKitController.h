//
//  PhotoKitController.h
//  yyy
//
//  Created by TangXing on 16/3/23.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PhotoKitController;

@protocol PhotoKitDelegate <NSObject>
- (void)photoKitController:(PhotoKitController *)photoKitController
               resultImage:(UIImage *)resultImage;

@end

@interface PhotoKitController : UIViewController

/** 1.原始图片, 必须设置*/
@property (nonatomic, strong) UIImage *imageOriginal;
/** 2.图片的尺寸,剪切框，最好是需求图片的2x, 默认是CGSizeMake(ScreenWidth, ScreenWidth); */
@property (nonatomic, assign) CGSize sizeClip;

@property (nullable, nonatomic, weak) id <PhotoKitDelegate> delegate ;

@end

NS_ASSUME_NONNULL_END
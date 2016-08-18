//
//  PhotoKitController.m
//  yyy
//
//  Created by TangXing on 16/3/23.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "PhotoKitController.h"
#import "UIImage+YYY.h"
#import "YYYUI.h"

NS_ASSUME_NONNULL_BEGIN
@interface PhotoKitController () <UIGestureRecognizerDelegate>

/** 1.图片 */
@property (nonatomic, strong) UIImageView *imageView;
/** 2.取消按钮 */
@property (nonatomic, strong) UIButton *buttonCancel;
/** 3.确认按钮 */
@property (nonatomic, strong) UIButton *buttonConfirm;
/** 4.覆盖图 */
@property (nonatomic, strong) UIView *viewOverlay;
/** 5.图片返回初始状态 */
@property (nonatomic, strong) UIButton *buttonBack;
/** 6.修剪的位置 */
@property (nonatomic, assign) CGRect rectClip;

@end

NS_ASSUME_NONNULL_END

@implementation PhotoKitController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sizeClip = CGSizeMake(kScreenWidth, kScreenHeight);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.viewOverlay setHollowWithCenterFrame:self.rectClip];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.imageView setCenter:self.view.center];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.viewOverlay];
    [self.view addSubview:self.buttonCancel];
    [self.view addSubview:self.buttonConfirm];
    [self.view addSubview:self.buttonBack];
    
    [self addGestureRecognizerToView:self.view];
    
}

#pragma mark - --- event response 事件相应 ---
/**
 *  1.取消操作
 */
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  2.确认操作
 */
- (void)confirm
{
    if ([self.delegate respondsToSelector:@selector(photoKitController:resultImage:)]) {
        [self.delegate photoKitController:self resultImage:[self getResultImage]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  3.返回原来位置
 */
- (void)recover
{
    [self.buttonBack setHidden:YES];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.imageView setTransform:CGAffineTransformMakeRotation(0)];
        self.imageView.center = self.view.center;
        self.imageView.size = [self imageviewSize:self.imageOriginal];
    } completion:^(BOOL finished) {
    }];
    
}
/**
 *  4.处理旋转手势
 */
- (void)rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    [self.buttonBack setHidden:NO];
    UIView *view = self.imageView;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}
/**
 *  5.处理缩放手势
 */
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    [self.buttonBack setHidden:NO];
    UIView *view = self.imageView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat scaleW = pinchGestureRecognizer.scale * view.size.width;
        CGFloat scaleH = pinchGestureRecognizer.scale * view.size.height;
        
        if (scaleW < 180 * 5) {
            if (scaleW > 180 && scaleH > 180) {
                view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
            }
        }
        
        pinchGestureRecognizer.scale = 1;
    }
}
/**
 *  6.处理拖拉手势
 */
- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [self.buttonBack setHidden:NO];
    UIView *view = self.imageView;
    
    view.backgroundColor = [UIColor redColor];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        
        CGFloat confineX = (kScreenWidth - 180)/2;
        CGFloat confineY = (kScreenHeight - 180)/2;
        
        CGFloat viewX = view.x + translation.x;
        CGFloat viewY = view.y + translation.y;
        
        CGFloat maxViewX = viewX + view.size.width;
        CGFloat maxViewY = viewY + view.size.height;
        
        if (viewX > confineX) {
            viewX = confineX;
        }
        if (viewY > confineY) {
            viewY = confineY;
        }
        if (maxViewX < confineX + 180) {
            viewX = confineX + 180 - view.size.width;
        }
        if (maxViewY < confineY + 180) {
            viewY = confineY + 180 - view.size.height;
        }
        
        [view setOrigin:(CGPoint){viewX,viewY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view];
    }
}

#pragma mark - --- private methods 私有方法 ---

/**
 *  1.添加所有的手势
 */
- (void) addGestureRecognizerToView:(UIView *)view
{
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
}

/**
 *  2.获取指定的图片
 *
 *  @return <#return value description#>
 */
- (UIImage *)getResultImage
{
    
    UIImage *image = [self.view imageFromSelfView];
    return [image croppedImage:self.rectClip];
}

#pragma mark - --- getters and setters 属性 ---

- (void)setImageOriginal:(UIImage *)imageOriginal
{
    _imageOriginal = imageOriginal;
    
    self.imageView.size = [self imageviewSize:imageOriginal];
    
    self.imageView.image = imageOriginal;
}

//设置imageview的size
- (CGSize)imageviewSize:(UIImage *)image
{
    CGFloat imgW = image.size.width;
    CGFloat imgH = image.size.height;
    
    CGFloat radioH = imgH / imgW;
    CGFloat radioW = imgW / imgH;
    
    CGSize imageViewSize = image.size;
    
    if (imgW > kScreenWidth) {
        
        imageViewSize.width = kScreenWidth;
        imageViewSize.height = kScreenWidth * radioH;
    }
    else if (imgH > kScreenHeight) {
        
        imageViewSize.height = kScreenHeight;
        imageViewSize.width = kScreenHeight * radioW;
        
    }
    
    return imageViewSize;
}

- (void)setSizeClip:(CGSize)sizeClip
{
    _sizeClip = sizeClip;
    CGFloat clipW = sizeClip.width;
    CGFloat clipH = sizeClip.height;
    CGFloat clipX = (kScreenWidth - clipW)/2;
    CGFloat clipY = (kScreenHeight - clipH)/2;
    _rectClip = CGRectMake(clipX, clipY, clipW, clipH);
}

/** 1.图片 */
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setUserInteractionEnabled:YES];
        [_imageView setMultipleTouchEnabled:YES];
    }
    return _imageView;
}

/** 2.取消按钮 */
- (UIButton *)buttonCancel
{
    if (!_buttonCancel) {
        CGFloat buttonW = 40;
        CGFloat buttonH = 28;
        CGFloat buttonX = YYYMarginBig;
        CGFloat buttonY = kScreenHeight - buttonH - YYYMarginBig;
        _buttonCancel = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        [_buttonCancel setBackgroundColor:YYYColorA(0, 0, 0, 50.0/255)];
        [_buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_buttonCancel setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
        [_buttonCancel.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [_buttonCancel setClipsToBounds:YES];
        [_buttonCancel.layer setCornerRadius:2];
        [_buttonCancel.layer setBorderWidth:0.5];
        [_buttonCancel.layer setBorderColor:YYYColorA(255, 255, 255, 60.0/255).CGColor];
        [_buttonCancel addTarget:self
                          action:@selector(cancel)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonCancel;
}

/** 3.确认按钮 */
- (UIButton *)buttonConfirm
{
    if (!_buttonConfirm) {
        CGFloat buttonW = 40;
        CGFloat buttonH = 28;
        CGFloat buttonX = kScreenWidth - buttonW - YYYMarginBig;
        CGFloat buttonY = kScreenHeight - buttonH - YYYMarginBig;
        _buttonConfirm = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        [_buttonConfirm setBackgroundColor:YYYColorA(0, 0, 0, 50.0/255)];
        [_buttonConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [_buttonConfirm setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
        [_buttonConfirm.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [_buttonConfirm setClipsToBounds:YES];
        [_buttonConfirm.layer setCornerRadius:2];
        [_buttonConfirm.layer setBorderWidth:0.5];
        [_buttonConfirm.layer setBorderColor:YYYColorA(255, 255, 255, 60.0/255).CGColor];
        [_buttonConfirm addTarget:self
                           action:@selector(confirm)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonConfirm;
}

/** 4.覆盖图 */
- (UIView *)viewOverlay
{
    if (!_viewOverlay) {
        
        _viewOverlay = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [_viewOverlay setBackgroundColor:[UIColor whiteColor]];
        [_viewOverlay setAlpha:0.5];
        
    }
    return _viewOverlay;
}

/** 5.图片返回初始状态 */
- (UIButton *)buttonBack
{
    if (!_buttonBack) {
        CGFloat buttonW = 40;
        CGFloat buttonH = 28;
        CGFloat buttonX = kScreenWidth - buttonW - YYYMarginBig;
        CGFloat buttonY = kScreenHeight - buttonH - YYYMarginBig;
        _buttonBack = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        [_buttonBack setCenterX:kScreenWidth/2];
        [_buttonBack setBackgroundColor:YYYColorA(0, 0, 0, 50.0/255)];
        [_buttonBack setTitle:@"复原" forState:UIControlStateNormal];
        [_buttonBack setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        [_buttonBack.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [_buttonBack setClipsToBounds:YES];
        [_buttonBack.layer setCornerRadius:2];
        [_buttonBack.layer setBorderWidth:0.5];
        [_buttonBack.layer setBorderColor:YYYColorA(255, 255, 255, 60.0/255).CGColor];
        [_buttonBack setHidden:YES];
        [_buttonBack addTarget:self
                        action:@selector(recover)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonBack;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

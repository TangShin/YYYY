//
//  YYYHomeViewController.h
//  
//
//  Created by TangXing on 15/10/10.
//
//

#import <UIKit/UIKit.h>
#import "YYYTitleView.h"

@interface YYYHomeViewController : UIViewController <UIScrollViewDelegate>

///@brife 下方的ScrollView
@property (strong, nonatomic) UIScrollView *scrollView;

///@brife 当前选中页数
@property (assign,nonatomic) NSInteger currentPage;

///@brife 当前选中的按钮
@property (assign,nonatomic) NSInteger currentTag;

///@brife 按钮之间的距离
@property (assign,nonatomic) CGFloat distanceBetweenButton;

///@brife 顶部视图
@property (strong,nonatomic) YYYTitleView *titleView;

///@brife 下划线
@property (strong,nonatomic) UIView *underLineView;

///@brife titleview的button
@property (strong,nonatomic) UIButton *recommendbtn;
@property (strong,nonatomic) UIButton *chartbtn;
@property (strong,nonatomic) UIButton *playlistbtn;
@property (strong,nonatomic) UIButton *otherbtn;

@end
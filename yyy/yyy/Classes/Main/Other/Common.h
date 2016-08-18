//
//  Common.h
//  
//
//  Created by TangXing on 15/10/10.
//
//

#ifndef TangShin___Common_h
#define TangShin___Common_h

//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f

#define kSixBnineH kScreenWidth*9/16

#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)

//RGB颜色
#define YYYColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//RGBA颜色
#define YYYColorA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//随机颜色
#define YYYRandomColor YYYColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))
//APP Main Color
#define YYYMainColor [UIColor colorWithRed:80/255.0 green:193/255.0 blue:233/255.0 alpha:1.0]
//APP Background Color
#define YYYBackGroundColor [UIColor colorWithRed:241/255.0 green:241/255.0 blue:245/255.0 alpha:1.0]

//广告的宽度
#define kAdViewWidth  _adScrollView.bounds.size.width
//广告的高度
#define kAdViewHeight  _adScrollView.bounds.size.height
//由于_pageControl是添加进父视图的,所以实际位置要参考,滚动视图的y坐标
#define HIGHT _adScrollView.bounds.origin.y
//navigationBarHeight
#define NaviBarHeight 64

//视频高宽比
#define kVideoHWRatio 9/16

//轮播高宽比
#define kbannerHWRatio 600/1600

//Documents路径
#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

/**
 *  4.弱引用
 */
#define WeakSelf __weak typeof(self) weakSelf = self;

#endif

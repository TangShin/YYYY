//
//  WriteView.h
//  UI
//
//  Created by TangXing on 16/4/19.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

//键盘类型
typedef NS_ENUM(NSInteger, YYYKeyboardType) {
    YYYKeyboardTypeDefault,
    YYYKeyboardTypeASCIICapable ,
    YYYKeyboardTypeNumbersAndPunctuation ,
    YYYKeyboardTypeURL ,
    YYYKeyboardTypeNumberPad ,
    YYYKeyboardTypePhonePad ,
    YYYKeyboardTypeNamePhonePad ,
    YYYKeyboardTypeEmailAddress ,
    YYYKeyboardTypeDecimalPad ,
    YYYKeyboardTypeTwitter ,
    YYYKeyboardTypeWebSearch ,
    YYYKeyboardTypeAlphabet = YYYKeyboardTypeASCIICapable,
    
};

//键盘return键类型
typedef NS_ENUM(NSInteger, YYYReturnKeyType) {
    YYYReturnKeyDefault,
    YYYReturnKeyGo,
    YYYReturnKeyGoogle,
    YYYReturnKeyJoin,
    YYYReturnKeyNext,
    YYYReturnKeyRoute,
    YYYReturnKeySearch,
    YYYReturnKeySend,
    YYYReturnKeyYahoo,
    YYYReturnKeyDone,
    YYYReturnKeyEmergencyCall,
    YYYReturnKeyContinue NS_ENUM_AVAILABLE_IOS(9_0),
};

@protocol WriteViewDelegate <NSObject>

- (void)returnWriteViewFrame:(CGRect)Frame;
- (void)sendContent;

@end

@interface WriteView : UIView

@property (assign,nonatomic) id <WriteViewDelegate> writeDelegate;
//键盘类型
@property (nonatomic) YYYKeyboardType writeViewKeyboardType;
//键盘return键类型
@property (nonatomic) YYYReturnKeyType writeViewReturnKeyType;

- (void)hiddenKeyboard;
- (NSString *)retuerTextViewText;

@end

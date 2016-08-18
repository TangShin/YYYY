//
//  PlaylistCollectionViewController.h
//  yyy
//
//  Created by TangXing on 16/2/29.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistCollectionViewController : UICollectionViewController

@property (strong,nonatomic) NSMutableArray *playlistData;
@property (copy,nonatomic) NSString *sortDiv;

@end

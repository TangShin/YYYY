//
//  MVCollectionViewController.m
//  yyy
//
//  Created by TangXing on 16/3/3.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "MVCollectionViewController.h"
#import "MVCollectionCell.h"
#import "PlayVideoViewController.h"

#import "UIImageView+WebCache.h"

@interface MVCollectionViewController ()

@end

@implementation MVCollectionViewController

static NSString *mvListID = @"mvListID";

-(instancetype)init
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mvListData = [[NSMutableArray alloc] init];
    
    [self.collectionView registerClass:[MVCollectionCell class] forCellWithReuseIdentifier:mvListID];
    
}

#pragma mark <UICollectionViewDataSource>
//定义每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPathcollectionView
{
    return CGSizeMake((kScreenWidth - 30)/2, (kScreenWidth - 30)/2*kVideoHWRatio + 70);
}

//定义每个uicollectionview的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//展示的section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//展示的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _mvListData.count;
}

//每个cell展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MVCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mvListID forIndexPath:indexPath];
    
    [cell.mvImg sd_setImageWithURL:[NSURL URLWithString:_mvListData[indexPath.row][@"videoPreviewAddr"]]];
    cell.mvImg.layer.masksToBounds = YES;
    cell.mvImg.layer.cornerRadius = 5;
    cell.mvName.text = _mvListData[indexPath.row][@"videoName"];
    
    if ([_sortDiv isEqualToString:VIDEO_SORT_TIME]) {
        
        cell.sortImg.image = [UIImage imageNamed:@"sortTime"];
        cell.sortLabel.text = _mvListData[indexPath.row][@"releaseTimeView"];
        
    } else if ([_sortDiv isEqualToString:VIDEO_SORT_FAVORITE_COUNT]) {
        
        cell.sortImg.image = [UIImage imageNamed:@"fvoritCount"];
        cell.sortLabel.text = _mvListData[indexPath.row][@"favoriteCount"];
        
    } else if ([_sortDiv isEqualToString:VIDEO_SORT_LIKE_COUNT]) {
        
        cell.sortImg.image = [UIImage imageNamed:@"likeCount"];
        cell.sortLabel.text = _mvListData[indexPath.row][@"likeCount"];
        
    } else if ([_sortDiv isEqualToString:VIDEO_SORT_PLAY_COUNT]) {
        
        cell.sortImg.image = [UIImage imageNamed:@"playCount"];
        cell.sortLabel.text = _mvListData[indexPath.row][@"playCount"];
        
    }
    
    return cell;
}

//UIcollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayVideoViewController *playVideoView = [[PlayVideoViewController alloc] init];
    playVideoView.videoId = _mvListData[indexPath.row][@"videoId"];
    [self.navigationController pushViewController:playVideoView animated:YES];
}

//collection的页眉
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

//collection的页脚
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

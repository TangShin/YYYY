//
//  PlaylistCollectionViewController.m
//  yyy
//
//  Created by TangXing on 16/2/29.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "PlaylistCollectionViewController.h"
#import "PlaylistCollectionViewCell.h"
#import "PlaylistViewController.h"

#import "UIImageView+WebCache.h"

@interface PlaylistCollectionViewController ()

@end

@implementation PlaylistCollectionViewController

static NSString *playlistID = @"playlistID";

-(instancetype)init
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _playlistData = [[NSMutableArray alloc] init];
    
    [self.collectionView registerClass:[PlaylistCollectionViewCell class] forCellWithReuseIdentifier:playlistID];
    
}

#pragma mark <UICollectionViewDataSource>
//定义每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPathcollectionView
{
    return CGSizeMake((kScreenWidth - 60)/2, (kScreenWidth - 60)/2 + 70);
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
    return _playlistData.count;
}

//每个cell展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlaylistCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:playlistID forIndexPath:indexPath];
    [cell.playlistImg sd_setImageWithURL:[NSURL URLWithString:_playlistData[indexPath.row][@"coverAddr"]]];
    cell.playlistTitle.text = _playlistData[indexPath.row][@"playlistName"];
    [cell.userPhoto sd_setImageWithURL:[NSURL URLWithString:_playlistData[indexPath.row][@"userPhoto"]]];
    cell.userPhoto.layer.masksToBounds = YES;
    cell.userPhoto.layer.cornerRadius = cell.userPhoto.size.width/2;
    cell.userPhoto.layer.borderWidth = 2;
    cell.userPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if ([_sortDiv isEqualToString:PLAYLIST_SORT_TIME]) {
        
        cell.sortImg.image = [UIImage imageNamed:@"sortTime"];
        cell.sortLabel.text = _playlistData[indexPath.row][@"releaseTimeView"];
        
    } else if ([_sortDiv isEqualToString:PLAYLIST_SORT_FAVORITE_COUNT]) {
        
        cell.sortImg.image = [UIImage imageNamed:@"fvoritCount"];
        cell.sortLabel.text = _playlistData[indexPath.row][@"favoriteCount"];
        
    } else if ([_sortDiv isEqualToString:PLAYLIST_SORT_LIKE_COUNT]) {
        
        cell.sortImg.image = [UIImage imageNamed:@"likeCount"];
        cell.sortLabel.text = _playlistData[indexPath.row][@"likeCount"];
    }
    
    return cell;
}

//UIcollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlaylistViewController *playlistview = [[PlaylistViewController alloc] init];
    playlistview.playlistId = _playlistData[indexPath.row][@"playlistId"];
    [self.navigationController pushViewController:playlistview animated:YES];
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

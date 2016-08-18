//
//  FirstViewController.m
//  yyy
//
//  Created by TangXing on 15/10/13.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "RecommendViewController.h"
#import "PlayVideoViewController.h"
#import "PlaylistViewController.h"

#import "YYYBanner.h"
#import "YYYHttpTool.h"
#import "UIImageView+WebCache.h"
#import "AdView.h"

#import "ReusableView.h"
//#import "RecommendClassName.h"
#import "VideoCollectionCell.h"
#import "MusicalCollectionCell.h"
#import "PlaylistCollectionCell.h"

#import "NoNetworkView.h"

#define VideoClass_RcomdPlaylist @"07"
#define VideoClass_RcomdMusical @"05"

@interface RecommendViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NoNetworkViewDelegate>
{
    AdView *adView;
}

@property (strong,nonatomic) NSMutableArray *bannerArray;
@property (strong,nonatomic) NSArray *videoData;

@property (assign,nonatomic) int videoDataCount;

@property (strong,nonatomic) NSMutableArray *rcomdArray;
@property (strong,nonatomic) NoNetworkView *noNetworkView;

@end

@implementation RecommendViewController
static NSString *videoCellID = @"videoCell";
static NSString *musicalID = @"musicalCell";
static NSString *playlistID = @"playlistCell";
static NSString *headerID = @"headerID";
static NSString *bannerID = @"bannerCell";

- (NoNetworkView *)noNetworkView
{
    if (!_noNetworkView) {
        self.noNetworkView = [[NoNetworkView alloc] initWithFrame:self.view.frame];
        self.noNetworkView.noNetworkDelegate = self;
    }
    return _noNetworkView;
}

-(instancetype)init
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bannerArray=[NSMutableArray array];
//    _titleArray=[NSMutableArray array];
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:bannerID];
    [self.collectionView registerClass:[VideoCollectionCell class] forCellWithReuseIdentifier:videoCellID];
    [self.collectionView registerClass:[MusicalCollectionCell class] forCellWithReuseIdentifier:musicalID];
    [self.collectionView registerClass:[PlaylistCollectionCell class] forCellWithReuseIdentifier:playlistID];
    [self.collectionView registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:headerID];
    
    [self loadData];
}

- (void)loadData
{
    [YYYHttpTool post:YYYLoadHomeURL params:nil success:^(id json) {
        
        self.bannerArray = json[@"hero"];
        self.videoData = json[@"recommend"];
        
        [self.collectionView reloadData];
        [self.noNetworkView removeFromSuperview];
        
    } failure:^(NSError *error) {
        
        [self.view addSubview:self.noNetworkView];
        TSLog(@"FAILERE_%@",error);
        
    }];
}

#pragma mark collectionviewDelegate
//定义每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSIndexPath *indexPath = indexPathcollectionView;
    NSString *videoClass = [[NSString alloc] init];
    if (indexPath.section != 0) {
        videoClass = self.videoData[indexPath.section-1][@"recommendList"][indexPath.row][@"recommendClass"];
    }
    
    //cell
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth,kScreenWidth * kbannerHWRatio);
    }
    else if ([videoClass isEqualToString: VideoClass_RcomdPlaylist])
    {
        return CGSizeMake((kScreenWidth - 60)/2, (kScreenWidth - 60)/2 + 70);
    }
    else if ([videoClass isEqualToString:VideoClass_RcomdMusical])
    {
        return CGSizeMake((kScreenWidth - 30)/2, 160);
    }
    return CGSizeMake((kScreenWidth - 30)/2, (kScreenWidth - 30)/2*kVideoHWRatio + 70);
}

//定义每个uicollectionview的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//展示的section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.videoData.count + 1;
}

//展示的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 1;
    } else {
        NSArray *sectionCount = self.videoData[section - 1][@"recommendList"];
        return sectionCount.count;
    }
}

//每个cell展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlstr,*title,*rcomdClass,*userPhoto,*comdCount,*playCount,*favoriteCount,*fansCount;
    NSURL *photoUrl;
    
    if (indexPath.section > 0) {
        urlstr = self.videoData[indexPath.section-1][@"recommendList"][indexPath.row][@"itemPreviewAddr"];
        title = self.videoData[indexPath.section-1][@"recommendList"][indexPath.row][@"itemName"];
        rcomdClass = self.videoData[indexPath.section-1][@"recommendList"][indexPath.row][@"recommendClass"];
        userPhoto = self.videoData[indexPath.section-1][@"recommendList"][indexPath.row][@"userPhoto"];
        comdCount = self.videoData[indexPath.section-1][@"recommendList"][indexPath.row][@"commentCount"];
        playCount = self.videoData[indexPath.section-1][@"recommendList"][indexPath.row][@"playCount"];
        favoriteCount = self.videoData[indexPath.section-1][@"recommendList"][indexPath.row][@"favoriteCount"];
        fansCount = self.videoData[indexPath.section-1][@"recommendList"][indexPath.row][@"fansCount"];
        photoUrl = [NSURL URLWithString:urlstr];
    }
    
    //其它cell
    if (indexPath.section == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bannerID forIndexPath:indexPath];
        
        [self setUpBanner];
        [cell.contentView addSubview:adView];
        return cell;
    }
    else if ([rcomdClass isEqualToString:VideoClass_RcomdMusical]) {
        MusicalCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:musicalID forIndexPath:indexPath];
        [cell.image sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"userIcon.png"]];
        cell.image.layer.masksToBounds = YES;
        cell.image.layer.cornerRadius = cell.image.size.width/2;
        cell.title.text = title;
        cell.fansCount.text = [NSString stringWithFormat:@"粉丝: %@",fansCount];
        return cell;
    }
    else if ([rcomdClass isEqualToString:VideoClass_RcomdPlaylist])
    {
        PlaylistCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:playlistID forIndexPath:indexPath];
        [cell.image sd_setImageWithURL:photoUrl];
        cell.title.text = title;
        [cell.userPhoto sd_setImageWithURL:[NSURL URLWithString:userPhoto]];
        cell.userPhoto.layer.masksToBounds = YES;
        cell.userPhoto.layer.cornerRadius = cell.userPhoto.size.width/2;
        cell.userPhoto.layer.borderWidth = 2;
        cell.userPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.firstImg.image = [UIImage imageNamed:@"fvoritCount"];
        cell.firstLabel.text = favoriteCount;
        cell.secondImg.image = [UIImage imageNamed:@"comdCount"];
        cell.secondLabel.text = comdCount;
        return cell;
    }
    else{
        VideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:videoCellID forIndexPath:indexPath];
        [cell.image sd_setImageWithURL:photoUrl];
        cell.image.layer.masksToBounds = YES;
        cell.image.layer.cornerRadius = 5;
        cell.title.text = title;
        cell.comentCount.text = comdCount;
        cell.playCount.text = playCount;
        return cell;
    }
}

//UIcollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *videoClass= [[NSString alloc] init];
    NSString *itemId = [[NSString alloc] init];
    if (indexPath.section > 0) {
        videoClass = self.videoData[indexPath.section - 1][@"recommendList"][indexPath.row][@"recommendClass"];
        itemId = self.videoData[indexPath.section - 1][@"recommendList"][indexPath.row][@"itemId"];
    }
    
    if ([videoClass isEqualToString:VideoClass_RcomdPlaylist] && itemId != nil) {
        
        PlaylistViewController *playlistView = [[PlaylistViewController alloc] init];
        playlistView.playlistId = itemId;
        [self.navigationController pushViewController:playlistView animated:YES];
        
    } else if ([videoClass isEqualToString:VideoClass_RcomdMusical]) {
        return;
    } else
    {
        PlayVideoViewController *playView = [[PlayVideoViewController alloc] init];
        playView.videoId = itemId;
        [self.navigationController pushViewController:playView animated:YES];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section >0) {
        ReusableView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        
        header.backgroundColor = [UIColor whiteColor];
        
        NSString *headerTitle = self.videoData[indexPath.section-1][@"recommendClassName"];
        
        header.text = headerTitle;
//        [header.moreClick addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section>0) {
        return CGSizeMake(0, 40);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == self.videoData.count && section != 0) {
        return CGSizeMake(kScreenWidth, 150);
    }
    return CGSizeZero;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

//创建banner
- (void)setUpBanner
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSMutableArray * models = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.bannerArray.count; i++)
    {
        YYYBanner * banner = [[YYYBanner alloc]init];
        banner.imageURL = self.bannerArray[i][@"picAddr"];
        banner.bannerName = self.bannerArray[i][@"introduction1"];
        [models addObject:banner];
    }
    adView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * kbannerHWRatio) modelArr:models imagePropertyName:@"imageURL" pageControlShowStyle:UIPageControlShowStyleLeft];
    [adView setAdTitlePropertyName:@"bannerName" withShowStyle:AdTitleShowStyleRight];
    
    //图片被点击后回调的方法
    adView.callBack = ^(NSInteger index,NSString * imageURL)
    {
        NSLog(@"被点中图片的索引:%ld---地址:%@",(long)index,imageURL);
    };
}

#pragma mark headerView上的button点击事件
- (void)moreClick:(UIButton *)sender
{
    TSLog(@"没有更多推荐了🐷");
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - NoNetWorkDelegate
- (void)NoNetworkViewClick
{
    [self loadData];
}
@end

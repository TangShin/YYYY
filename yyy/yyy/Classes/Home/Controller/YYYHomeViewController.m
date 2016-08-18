//
//  YYYHomeViewController.m
//
//
//  Created by TangXing on 15/10/10.
//
//

#import "YYYHomeViewController.h"
#import "YYYTitleView.h"
#import "RecommendViewController.h"
#import "ChartViewController.h"
#import "PlaylistHomeViewController.h"
#import "OtherViewController.h"

@implementation YYYHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //button间距
    _distanceBetweenButton = 4;
    self.view.backgroundColor = [UIColor clearColor];
    [self buildTitleView];
    [self buildMainView];
    [self addchildView];
}

#pragma mark 添加子视图
- (void)addchildView
{
    RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
    ChartViewController *chartVC = [[ChartViewController alloc] init];
    PlaylistHomeViewController *playlistVC = [[PlaylistHomeViewController alloc] init];
    OtherViewController *otherVC = [[OtherViewController alloc] init];
    
    [recommendVC.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [chartVC.view setFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    [playlistVC.view setFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kScreenHeight)];
    [otherVC.view setFrame:CGRectMake(kScreenWidth * 3, 0, kScreenWidth, kScreenHeight - 113)];
    
    [self addChildViewController:recommendVC];
    [self addChildViewController:chartVC];
    [self addChildViewController:playlistVC];
    [self addChildViewController:otherVC];
    
    [_scrollView addSubview:recommendVC.view];
    [_scrollView addSubview:chartVC.view];
    [_scrollView addSubview:playlistVC.view];
    [_scrollView addSubview:otherVC.view];
}

#pragma mark -
#pragma mark 创建主视图
- (void)buildMainView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 4, kScreenHeight); //设置可滚动范围
    _scrollView.pagingEnabled = YES;  //开启交互
    _scrollView.canCancelContentTouches = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = FALSE; //不显示左右滑动条
    _scrollView.bounces = NO; // 去除弹簧效果
    _scrollView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;// 去除自偏移

    [self.view addSubview:_scrollView];
}

#pragma mark scrollview点击事件处理


#pragma mark scrollview代理方法
///拖拽后调用的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView])
    {
        _currentPage = _scrollView.contentOffset.x/kScreenWidth;
        
        if (_currentPage == 0) {
            _recommendbtn.selected = YES;
            _chartbtn.selected = NO;
            _playlistbtn.selected = NO;
            _otherbtn.selected = NO;
        } else if (_currentPage == 1) {
            _recommendbtn.selected = NO;
            _chartbtn.selected = YES;
            _playlistbtn.selected = NO;
            _otherbtn.selected = NO;
        } else if (_currentPage == 2) {
            _recommendbtn.selected = NO;
            _chartbtn.selected = NO;
            _playlistbtn.selected = YES;
            _otherbtn.selected = NO;
        } else if (_currentPage == 3) {
            _recommendbtn.selected = NO;
            _chartbtn.selected = NO;
            _playlistbtn.selected = NO;
            _otherbtn.selected = YES;
        }
        return;
    }

}

//scrollview滑动事件响应
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_scrollView isEqual:scrollView]) {
        
        CGRect frame = _underLineView.frame;
        
        frame.origin.x = scrollView.contentOffset.x/4;
        
        [_underLineView setX:frame.origin.x];
        
        CGFloat buttonWidth = _titleView.frame.size.width/4;
        CGFloat offsetX = buttonWidth/5;
        
        if (_underLineView.origin.x <= buttonWidth) {
            
            if (frame.origin.x <= offsetX) {
                _recommendbtn.titleLabel.textColor = YYYColor(255, 102, 153);
                _chartbtn.titleLabel.textColor = YYYColor(126,119,121);
            } else if (frame.origin.x <= offsetX * 2 && frame.origin.x >= offsetX){
                _recommendbtn.titleLabel.textColor = YYYColor(215, 107, 143);
                _chartbtn.titleLabel.textColor = YYYColor(161,114,130);
            } else if (frame.origin.x <= offsetX * 3 && frame.origin.x >= offsetX *2) {
                _recommendbtn.titleLabel.textColor = YYYColor(186, 111, 136);
                _chartbtn.titleLabel.textColor = YYYColor(186, 111, 136);
            } else if (frame.origin.x <= offsetX * 4 && frame.origin.x >= offsetX *3) {
                _recommendbtn.titleLabel.textColor = YYYColor(161,114,130);
                _chartbtn.titleLabel.textColor = YYYColor(215, 107, 143);
            } else {
                _recommendbtn.titleLabel.textColor = YYYColor(126,119,121);
                _chartbtn.titleLabel.textColor = YYYColor(255, 102, 153);
            }
            
        } else if (_underLineView.origin.x <= buttonWidth * 2 && _underLineView.origin.x >= buttonWidth) {
            if (frame.origin.x - buttonWidth<= offsetX) {
                _chartbtn.titleLabel.textColor = YYYColor(255, 102, 153);
                _playlistbtn.titleLabel.textColor = YYYColor(126,119,121);
            } else if (frame.origin.x - buttonWidth <= offsetX * 2 && frame.origin.x >= offsetX){
                _chartbtn.titleLabel.textColor = YYYColor(215, 107, 143);
                _playlistbtn.titleLabel.textColor = YYYColor(161,114,130);
            } else if (frame.origin.x - buttonWidth <= offsetX * 3 && frame.origin.x >= offsetX *2) {
                _chartbtn.titleLabel.textColor = YYYColor(186, 111, 136);
                _playlistbtn.titleLabel.textColor = YYYColor(186, 111, 136);
            } else if (frame.origin.x - buttonWidth <= offsetX * 4 && frame.origin.x >= offsetX *3) {
                _chartbtn.titleLabel.textColor = YYYColor(161,114,130);
                _playlistbtn.titleLabel.textColor = YYYColor(215, 107, 143);
            } else {
                _chartbtn.titleLabel.textColor = YYYColor(126,119,121);
                _playlistbtn.titleLabel.textColor = YYYColor(255, 102, 153);
            }
        } else if (_underLineView.origin.x <= buttonWidth * 3 && _underLineView.origin.x >= buttonWidth * 2) {
            if (frame.origin.x - buttonWidth * 2 <= offsetX) {
                _playlistbtn.titleLabel.textColor = YYYColor(255, 102, 153);
                _otherbtn.titleLabel.textColor = YYYColor(126,119,121);
            } else if (frame.origin.x - buttonWidth * 2 <= offsetX * 2 && frame.origin.x >= offsetX){
                _playlistbtn.titleLabel.textColor = YYYColor(215, 107, 143);
                _otherbtn.titleLabel.textColor = YYYColor(161,114,130);
            } else if (frame.origin.x - buttonWidth * 2 <= offsetX * 3 && frame.origin.x >= offsetX *2) {
                _playlistbtn.titleLabel.textColor = YYYColor(186, 111, 136);
                _otherbtn.titleLabel.textColor = YYYColor(186, 111, 136);
            } else if (frame.origin.x - buttonWidth * 2 <= offsetX * 4 && frame.origin.x >= offsetX *3) {
                _playlistbtn.titleLabel.textColor = YYYColor(161,114,130);
                _otherbtn.titleLabel.textColor = YYYColor(215, 107, 143);
            } else {
                _playlistbtn.titleLabel.textColor = YYYColor(126,119,121);
                _otherbtn.titleLabel.textColor = YYYColor(255, 102, 153);
            }
        }
    }
}

#pragma mark -
#pragma mark 创建titleview
- (void)buildTitleView
{
    _titleView = [[YYYTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    _titleView.backgroundColor = [UIColor whiteColor];
    
    _recommendbtn = [self steupButtonWithName:@"推荐" selected:YES tag:0];
    _currentTag = _recommendbtn.tag;
    [_titleView addSubview:_recommendbtn];
    
    _chartbtn = [self steupButtonWithName:@"排行榜" selected:NO tag:1];
    [_titleView addSubview:_chartbtn];
    
    _playlistbtn = [self steupButtonWithName:@"歌单" selected:NO tag:2];
    [_titleView addSubview:_playlistbtn];
    
    _otherbtn = [self steupButtonWithName:@"其它" selected:NO tag:3];
    [_titleView addSubview:_otherbtn];
    
    //下划线x坐标
    CGFloat underLineViewX = kScreenWidth / 4;
    _underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, underLineViewX, 4)];
    _underLineView.backgroundColor = YYYColor(255, 102, 153);
    _underLineView.tag = 4;
    [_titleView addSubview:_underLineView];
    
    _recommendbtn.translatesAutoresizingMaskIntoConstraints = false;
    _chartbtn.translatesAutoresizingMaskIntoConstraints = false;
    _playlistbtn.translatesAutoresizingMaskIntoConstraints = false;
    _otherbtn.translatesAutoresizingMaskIntoConstraints = false;
    _underLineView.translatesAutoresizingMaskIntoConstraints = false;

    NSMutableArray *vfls = [NSMutableArray array];
    
    NSString *recommend_V = @"V:|-0-[_recommendbtn]-0-|";
    NSString *recommend_H = @"H:|-0-[_recommendbtn]";
    NSString *chart_V = @"V:|-0-[_chartbtn]-0-|";
    NSString *chart_H = @"H:[_recommendbtn]-distance-[_chartbtn(==_recommendbtn)]";
    NSString *playlist_V = @"V:|-0-[_playlistbtn]-0-|";
    NSString *playlist_H = @"H:[_chartbtn]-distance-[_playlistbtn(==_recommendbtn)]";
    NSString *other_V = @"V:|-0-[_otherbtn]-0-|";
    NSString *other_H = @"H:[_playlistbtn]-distance-[_otherbtn(==_recommendbtn)]";
    
    [vfls addObject:recommend_V];
    [vfls addObject:recommend_H];
    [vfls addObject:chart_V];
    [vfls addObject:chart_H];
    [vfls addObject:playlist_V];
    [vfls addObject:playlist_H];
    [vfls addObject:other_V];
    [vfls addObject:other_H];
 
    [_titleView addConstraint:
     [NSLayoutConstraint constraintWithItem:_recommendbtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_titleView attribute:NSLayoutAttributeWidth multiplier:0.255 constant: -_distanceBetweenButton]];
    
    for (NSString *vfl in vfls) {
        
        [_titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl
          options:NSLayoutFormatAlignAllBaseline
          metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(44),@"tHeight",@(_distanceBetweenButton) ,@"distance",nil]
          views:[NSDictionary dictionaryWithObjectsAndKeys:_recommendbtn,@"_recommendbtn",_chartbtn,@"_chartbtn",_playlistbtn,@"_playlistbtn", _otherbtn,@"_otherbtn",nil]]];
        
    }
    
    [_titleView setNeedsUpdateConstraints];
    
    self.navigationItem.titleView = _titleView;
}

/**
 *  创建button
 *
 *  @param name     button名字
 *  @param selected 是否被是选中状态
 *  @param tag      button的tag
 *
 *  @return 返回一个button
 */
- (UIButton *)steupButtonWithName:(NSString *)name selected:(BOOL)selected tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.selected = selected;
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:YYYColor(126,119,121) forState:UIControlStateNormal];
    [button setTitleColor:YYYColor(255, 102, 153) forState:UIControlStateSelected];
    [button addTarget:self action:@selector(didCilickSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    return button;
}

/**
 *  button点击事件
 *
 *  @param sender 被点击的button
 */
- (void)didCilickSelectButton:(UIButton *)sender
{
    if (sender.selected && sender.tag == _currentTag) {
        return;
    }
    sender.selected = !sender.selected;
    _currentTag = sender.tag;

    UIView *underLineView = [[UIView alloc] init];
    
    NSArray *subviews = [NSArray array];
    subviews = sender.superview.subviews;
    
    if (subviews != nil) {
        
        for (UIView *v in subviews) {
            
            if (v.tag != sender.tag && v.tag != 4) {
                
                UIButton *button = (UIButton *)v;
                button.selected = false;
                
            }
            if (v.tag == 4) {
                
                underLineView = v;
                
            }
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [underLineView setX:_titleView.frame.size.width / 4 * sender.tag];
        //scrollview位移
        [_scrollView setContentOffset:CGPointMake(sender.tag * kScreenWidth, 0) animated:NO];
        
    }];
    
}

@end

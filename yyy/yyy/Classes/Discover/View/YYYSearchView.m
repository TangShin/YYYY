//
//  YYYSearchView.m
//  yyy
//
//  Created by TangXing on 16/3/1.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "YYYSearchView.h"

@interface YYYSearchView () <UISearchBarDelegate>
/**
 *  取消按钮
 */
@property (nonatomic,strong)UIButton *cancelBtn;
/**
 *  遮罩层
 */
@property (nonatomic,strong)UIButton *maskView;

@end

@implementation YYYSearchView
{
    CGRect _frame;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, kScreenWidth, 64);
        _frame = self.frame;
        self.backgroundColor = YYYMainColor;
        [self addSubview:[self searchBar]];
    }
    return self;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
        _searchBar.delegate = self;
        [_searchBar setBackgroundColor:[UIColor clearColor]];
        _searchBar.barTintColor = YYYMainColor;
        _searchBar.autocorrectionType=UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;
        [[[_searchBar.subviews objectAtIndex:0].subviews objectAtIndex:0]removeFromSuperview];
        _searchBar.placeholder = NSLocalizedString(_placeholder, @"please add string file");
    }
    return _searchBar;
}
- (UIButton *)cancelBtn{
    if ( !_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        _cancelBtn.frame = CGRectMake(kScreenWidth, 20, 50, 44);
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelBtn addTarget:self action:@selector(HiddenMaskView) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelBtn;
}
- (UIButton *)maskView{
    if (!_maskView) {
        _maskView = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        _maskView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hurtUandMe"]];
        [_maskView addTarget:self action:@selector(HiddenMaskView) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _maskView;
}
- (UITableView *)searchResultTableView{
    if (!_searchResultTableView) {
        _searchResultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
        _searchResultTableView.delegate = _searchResultsDelegate;
        _searchResultTableView.dataSource = _searchResultsDataSource;
    }
    return _searchResultTableView;
}

#pragma mark -
- (void)ShowMaskView{
    [self.superview addSubview:[self maskView]];
    [self addSubview:[self cancelBtn]];
    _maskView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 49);
    
    [UIView animateWithDuration:.2 animations:^{
        
        _searchBar.frame = CGRectMake(0, 20, kScreenWidth - 50, 44);
        _cancelBtn.frame = CGRectMake(kScreenWidth - 50, 20, 50, 44);
        
    }];
}
- (void)HiddenMaskView{
    [UIView animateWithDuration:.2 animations:^{
        
        _cancelBtn.frame = CGRectMake(kScreenWidth, 20, 50, 44);
        _searchBar.frame = CGRectMake(0, 20, kScreenWidth, 44);
        
    } completion:^(BOOL finished) {
        _searchBar.text = @"";
        [_searchBar resignFirstResponder];
        if (_maskView.subviews.count > 0) {
            [[_maskView.subviews objectAtIndex:0]removeFromSuperview];
        }
        [_maskView removeFromSuperview];
        [_searchResultTableView removeFromSuperview];
    }];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self ShowMaskView];
    if (searchBar.text.length == 0) {
        _maskView.hidden = YES;
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (_delegate) {
        [_delegate searchBarSearchButtonClicked:searchBar];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (_delegate) {
        if (searchBar.text.length != 0) {
            _maskView.hidden = NO;
            [_maskView addSubview:[self searchResultTableView]];
        }
        [_delegate searchBar:searchBar textDidChange:searchText];
    }
}

@end

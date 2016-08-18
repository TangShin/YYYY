//
//  SubCommentView.m
//  yyy
//
//  Created by TangXing on 15/12/14.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "SubCommentView.h"
#import "YYYLoginViewController.h"
#import "YYYHttpTool.h"
#import "UserInfoTool.h"
#import "ComentViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

@interface SubCommentView ()

@property (strong,nonatomic) NSDictionary *subMediaDic;
@property (strong,nonatomic) NSMutableArray *subMediaList;

@property (assign,nonatomic) bool next;//是否有下一页
//评论当前页
@property (strong,nonatomic) NSString *subCommentPage;
//cell复用判断数组
@property (strong,nonatomic) NSMutableArray *cellSelecArray;
//父评论是否被赞
@property (assign,nonatomic) BOOL supportMedia;
//父评论被赞后的count
@property (strong,nonatomic) NSString *mediaSupportCount;
//回复框载体
@property (strong,nonatomic) UIView *subCommentView;
//创建回复框
@property (retain,nonatomic) UITextView *TextViewInput;
//占位文字
@property (retain,nonatomic) UITextView *placeholderLabel;
//创建回复按钮
@property (retain,nonatomic) UIButton *btnSendComment;
//纪录被点击的行数
@property (assign,nonatomic) NSInteger selectedRow;
//显示子评论的tableview
@property (strong,nonatomic) UITableView *tableview;
//收起/弹出键盘
@property (assign,nonatomic) BOOL keyboardIsHidden;

@end

@implementation SubCommentView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论详情";
    _subMediaList = [[NSMutableArray alloc] init];
    _cellSelecArray = [[NSMutableArray alloc] init];
    _supportMedia = NO;
    _keyboardIsHidden = YES;
    _selectedRow = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 60) style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = YYYColor(223, 223, 223);
    [self.view addSubview:_tableview];
    
    [self setupCommentBoxView];
    
    [self loadData];
    
    [self loadMoreData];
    
    //获取键盘的高度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)loadData
{
    UserInfo *userInfo = [UserInfoTool userInfo];
    if (userInfo.userId == nil) {
        
        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录.\n_(:з)∠)_" delegate:self cancelButtonTitle:@"不登录" otherButtonTitles:@"登录", nil];
        [logoutAlert show];
        
    } else {
        NSDictionary *prameters = [[NSDictionary alloc] init];
        prameters = [NSDictionary dictionaryWithObjectsAndKeys:_videoId,@"mediaId",
                                                                @"1",@"pageButton",
                                                                @"1",@"page",
                                                                [NSNumber numberWithInteger:_mediaIndex],@"mediaIndex",
                                                                _timestamp,@"timestamp",nil];

        
        [YYYHttpTool post:YYYSubMediaPagingURL params:prameters success:^(id json) {
            
            _subMediaDic = json;
            self.next = _subMediaDic[@"next"];
            self.subCommentPage = _subMediaDic[@"page"];
            for (NSDictionary *subComent in _subMediaDic[@"mediaList"]) {
                [_subMediaList addObject:subComent];
                [self.cellSelecArray addObject:@"0"];
            }
            [_tableview reloadData];
        } failure:^(NSError *error) {
            TSLog(@"失败");
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_subMediaList.count > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return _subMediaList.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        NSString *tittle = [NSString stringWithFormat:@"相关评论  共%@条",_subMediaDic[@"totalCount"]];
        return tittle;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 25;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

//设置tableview的高度自动获取
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

//设置tableview的高度自动获取
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *iconImage = [[UIImageView alloc] init];
    
    BOOL nibRegistered = NO;
    if (!nibRegistered) {
        UINib *comentNib = [UINib nibWithNibName:@"ComentViewCell" bundle:nil];
        [tableView registerNib:comentNib forCellReuseIdentifier:@"ComentCell"];
        
        nibRegistered = YES;
    }
    
    ComentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComentCell"];
    
    if (indexPath.section == 1) {
        [iconImage sd_setImageWithURL:_subMediaList[indexPath.row][@"userPhoto"]];
        cell.icon.image = [self scaleImageSize:CGSizeMake(40, 40) image:iconImage];
        cell.icon.layer.masksToBounds = YES;
        cell.icon.layer.cornerRadius = cell.icon.bounds.size.width/2;
        cell.userName.text = _subMediaList[indexPath.row][@"userName"];
        cell.floor.text = _subMediaList[indexPath.row][@"floor"];
        cell.timeView.text = _subMediaList[indexPath.row][@"subTimeView"];
        NSString *reUserName = _subMediaList[indexPath.row][@"reUserName"];
        if ((NSNull *)reUserName == [NSNull null]) {
            cell.coment.text = [self decodeFromHTML:_subMediaList[indexPath.row][@"content"]];
        } else {
            cell.coment.text = [self subDecodeFromHTML:_subMediaList[indexPath.row][@"content"] Row:indexPath.row];
            NSRange range1 = [cell.coment.text rangeOfString:@"回复"];
            NSRange range2 = [cell.coment.text rangeOfString:@": "];
            NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc] initWithString:cell.coment.text];
            [attribut addAttributes:@{NSForegroundColorAttributeName:YYYColor(0, 204, 255)}  range:NSMakeRange(0, range1.location)];
            [attribut addAttributes:@{NSForegroundColorAttributeName:YYYColor(0, 204, 255)} range:NSMakeRange(range1.location+2, range2.location-range1.location-1)];
            cell.coment.attributedText = attribut;
        }
        
        cell.subMediaCount.hidden = YES;
        cell.supportCount.tag = indexPath.row;
        NSString *supportCount = [NSString stringWithFormat:@"%@",_subMediaList[indexPath.row][@"supportCount"]];
        [cell.supportCount addTarget:self action:@selector(subSupportCountAdd:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.cellSelecArray[indexPath.row] integerValue] == 0) {
            [cell.supportCount setTitle:supportCount forState:UIControlStateNormal];
            [cell.supportCount setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
            cell.supportCount.selected = NO;
        } else {
            [cell.supportCount setTitle:[NSString stringWithFormat:@"%@",self.cellSelecArray[indexPath.row]] forState:UIControlStateSelected];
            [cell.supportCount setImage:[UIImage imageNamed:@"supported"] forState:UIControlStateSelected];
            cell.supportCount.selected = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    [iconImage sd_setImageWithURL:_selectedMedia[@"userPhoto"]];
    cell.icon.image = [self scaleImageSize:CGSizeMake(40, 40) image:iconImage];
    cell.icon.layer.masksToBounds = YES;
    cell.icon.layer.cornerRadius = cell.icon.bounds.size.width/2;
    cell.userName.text = _selectedMedia[@"userName"];
    cell.floor.text = _selectedMedia[@"floor"];
    cell.timeView.text = _selectedMedia[@"timeView"];
    cell.coment.text = [self decodeFromHTML:_selectedMedia[@"content"]];
    if ([_selectedMedia[@"subMediaCount"] integerValue] > 0) {
        NSString *subMediaCount = [NSString stringWithFormat:@"%@",_selectedMedia[@"subMediaCount"]];
        [cell.subMediaCount setTitle:subMediaCount forState:UIControlStateNormal];
        cell.subMediaCount.hidden = NO;
    } else {
        cell.subMediaCount.hidden = YES;
    }
    [cell.supportCount addTarget:self action:@selector(selectedSupportCountAdd:) forControlEvents:UIControlEventTouchUpInside];
    NSString *supportCount = [NSString stringWithFormat:@"%@",_selectedMedia[@"supportCount"]];
    if (_supportMedia == NO) {
        [cell.supportCount setTitle:supportCount forState:UIControlStateNormal];
        [cell.supportCount setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
        cell.supportCount.selected = NO;
    } else if (_supportMedia == YES) {
        [cell.supportCount setTitle:_mediaSupportCount forState:UIControlStateNormal];
        [cell.supportCount setImage:[UIImage imageNamed:@"supported"] forState:UIControlStateSelected];
        cell.supportCount.selected = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_keyboardIsHidden == NO) {
        [_TextViewInput resignFirstResponder];
        _subCommentView.frame = CGRectMake(0, self.view.frame.size.height - 40, kScreenWidth, 40);
        _keyboardIsHidden = YES;
    } else {
        if (indexPath.section == 0) {
            _placeholderLabel.text = [NSString stringWithFormat:@"回复 @%@: ",_selectedMedia[@"userName"]];
            _placeholderLabel.textColor = YYYColor(160, 160, 160);
            [_TextViewInput becomeFirstResponder];
            _selectedRow = -1;
        }
        if (indexPath.section == 1) {
            _placeholderLabel.text = [NSString stringWithFormat:@"回复 @%@: ",_subMediaList[indexPath.row][@"userName"]];
            _placeholderLabel.textColor = YYYColor(160, 160, 160);
            [_TextViewInput becomeFirstResponder];
            _selectedRow = indexPath.row;
        }
        _keyboardIsHidden = NO;
    }
}

#pragma mark - textview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        _placeholderLabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        _placeholderLabel.hidden = NO;
    }
    return YES;
}

#pragma mark -
#pragma mark 支持事件
- (void)subSupportCountAdd:(UIButton *)sender
{
    NSDictionary *prametersSupport = [[NSDictionary alloc] init];
    prametersSupport = [NSDictionary dictionaryWithObjectsAndKeys:self.videoId,@"mediaId",
                                                                  _selectedMedia[@"timestamp"],@"timestamp",
                                                                  [UserInfoTool userInfo].userId,@"supportUserId",
                                                                  [NSNumber numberWithInteger:sender.tag],@"mediaIndex",
                                                                _subMediaList[sender.tag][@"subTimestamp"],@"subTimestamp",nil];
    
    [YYYHttpTool post:YYYSubMediaSupportURL params:prametersSupport success:^(id json) {
        
        int supportCount =[json[@"supportCount"] intValue];
        self.cellSelecArray[sender.tag] = json[@"supportCount"];
        [sender setTitle:[NSString stringWithFormat:@"%d",supportCount] forState:UIControlStateSelected];
        [sender setImage:[UIImage imageNamed:@"supported"] forState:UIControlStateSelected];
        sender.selected = YES;
        
    } failure:^(NSError *error) {
        TSLog(@"hey man");
    }];
}

#pragma mark 父评论支持事件
- (void)selectedSupportCountAdd:(UIButton *)sender
{
    NSDictionary *prametersSupport = [[NSDictionary alloc] init];
    prametersSupport = [NSDictionary dictionaryWithObjectsAndKeys:self.videoId,@"mediaId",
                                                                  _selectedMedia[@"timestamp"],@"timestamp",
                                                                  [UserInfoTool userInfo].userId,@"supportUserId",
                                                                  [NSNumber numberWithInteger:0],@"mediaIndex",nil];
    
    [YYYHttpTool post:YYYMediaSupportURL params:prametersSupport success:^(id json) {
        
        _supportMedia = YES;
        int supportCount =[json[@"supportCount"] intValue];
        _mediaSupportCount = [NSString stringWithFormat:@"%d",supportCount];
        [sender setTitle:_mediaSupportCount forState:UIControlStateSelected];
        [sender setImage:[UIImage imageNamed:@"supported"] forState:UIControlStateSelected];
        sender.selected = YES;
        
    } failure:^(NSError *error) {
        TSLog(@"hey man");
    }];
}

#pragma mark 创建回复输入框
- (void)setupCommentBoxView
{
    //创建回复框载体
    _subCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40 - 64, kScreenWidth, 40)];
    _subCommentView.backgroundColor = [UIColor whiteColor];
    
    //占位字符
    self.placeholderLabel = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth - 70, 30)];
    self.placeholderLabel.layer.cornerRadius = 4;
    self.placeholderLabel.layer.masksToBounds = YES;
    self.placeholderLabel.delegate = self;
    self.placeholderLabel.layer.borderWidth = 1;
    self.placeholderLabel.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
    self.placeholderLabel.editable = NO;
    [_subCommentView addSubview:self.placeholderLabel];
    
    //输入框
    self.TextViewInput = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth - 70, 30)];
    self.TextViewInput.layer.cornerRadius = 4;
    self.TextViewInput.layer.masksToBounds = YES;
    self.TextViewInput.delegate = self;
    self.TextViewInput.layer.borderWidth = 1;
    self.TextViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
    self.TextViewInput.backgroundColor = [UIColor clearColor];
    [_subCommentView addSubview:self.TextViewInput];
    
    //发送消息
    self.btnSendComment = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSendComment.frame = CGRectMake(CGRectGetMaxX(self.TextViewInput.frame) + 10, 5, 40, 30);
    [self.btnSendComment setTitle:@"Send" forState:UIControlStateNormal];
    [self.btnSendComment setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.btnSendComment.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.btnSendComment addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    [_subCommentView addSubview:self.btnSendComment];
    
    [self.view addSubview:_subCommentView];
}

#pragma mark - 上拉刷新下拉加载
-(void)loadMoreData
{
    _tableview.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSDictionary *prametersRefish = [[NSDictionary alloc] init];
        prametersRefish = [NSDictionary dictionaryWithObjectsAndKeys:_videoId,@"mediaId",
                                                                    @"1",@"pageButton",
                                                                    @"1",@"page",
                                                                    [NSNumber numberWithInteger:_mediaIndex],@"mediaIndex",
                                                                    _timestamp,@"timestamp",nil];
        
        [YYYHttpTool post:YYYSubMediaPagingURL params:prametersRefish success:^(id json) {
            
            [_subMediaList removeAllObjects];
            [self.cellSelecArray removeAllObjects];
            _subMediaDic = json;
            for (NSDictionary *subMedia in _subMediaDic[@"mediaList"]) {
                [_subMediaList addObject:subMedia];
                [self.cellSelecArray addObject:@"0"];
            }
            
            self.subCommentPage = json[@"page"];
            self.next = [json[@"next"] intValue];
            
            [_tableview reloadData];
            [_tableview.header endRefreshing];
            
        } failure:^(NSError *error) {
            [_tableview.header endRefreshing];
        }];
        
    }];
    
    if (self.next) {
        _tableview.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.next) {
                NSDictionary *prametersMediapaging = [[NSDictionary alloc] init];
                prametersMediapaging = [NSDictionary dictionaryWithObjectsAndKeys:_videoId,@"mediaId",
                                                                                  @"下页",@"pageButton",
                                                                                  self.subCommentPage,@"page",
                                                                                  [NSNumber numberWithInteger:_mediaIndex],@"mediaIndex",
                                                                                  _timestamp,@"timestamp",nil];
                
                [YYYHttpTool post:YYYSubMediaPagingURL params:prametersMediapaging success:^(id json) {
                    
                    NSDictionary *subMediaComent = json;
                    self.subCommentPage = subMediaComent[@"page"];
                    self.next = [subMediaComent[@"next"] intValue];
                    NSArray *array = [subMediaComent valueForKey:@"mediaList"];
                    
                    for (NSDictionary *subMedia in array) {
                        [_subMediaList addObject:subMedia];
                        [self.cellSelecArray addObject:@"0"];
                    }
                    
                    [_tableview reloadData];
                    [_tableview.footer endRefreshing];
                    
                } failure:^(NSError *error) {
                    [_tableview.footer endRefreshing];
                }];
            } else {
                [_tableview.footer endRefreshing];
            }
        }];
    }
    
//    _tableview.footer.hidden = YES;
}

#pragma mark 发送回复
- (void)sendComment:(UIButton *)sender
{
    UserInfo *userInfo = [UserInfoTool userInfo];
    if (userInfo.userId == nil) {
        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录.\n_(:з)∠)_" delegate:self cancelButtonTitle:@"不登录" otherButtonTitles:@"登录", nil];
        [logoutAlert show];
    } else if (_selectedRow != -1) {
        NSDictionary *prameters = [[NSDictionary alloc] init];
        prameters = [NSDictionary dictionaryWithObjectsAndKeys:self.videoId,@"mediaId",
                                                               self.TextViewInput.text,@"content",
                                                               userInfo.userId,@"userId",
                                                               _timestamp,@"timestamp",
                                                               [NSNumber numberWithInteger:_mediaIndex],@"mediaIndex",
                                                               _subMediaList[_selectedRow][@"subTimestamp"],@"reTimestamp",nil];
        
        [YYYHttpTool post:YYYSubMediaAddURL params:prameters success:^(id json) {
            
            _subMediaDic = json;
            self.TextViewInput.text = @"";
            [self.TextViewInput resignFirstResponder];
            _subCommentView.frame = CGRectMake(0, self.view.frame.size.height - 40, kScreenWidth, 40);
            self.next = _subMediaDic[@"next"];
            self.subCommentPage = _subMediaDic[@"page"];
            [_subMediaList removeAllObjects];
            [_cellSelecArray removeAllObjects];
            for (NSDictionary *subComent in _subMediaDic[@"mediaList"]) {
                [_subMediaList addObject:subComent];
                [_cellSelecArray addObject:@"0"];
            }
            [_tableview reloadData];
            
        } failure:^(NSError *error) {
            TSLog(@"Hey Man");
        }];
    } else {
        NSDictionary *prameters = [[NSDictionary alloc] init];
        prameters = [NSDictionary dictionaryWithObjectsAndKeys:self.videoId,@"mediaId",
                                                               self.TextViewInput.text,@"content",
                                                               userInfo.userId,@"userId",
                                                               _timestamp,@"timestamp",
                                                               [NSNumber numberWithInteger:_mediaIndex],@"mediaIndex",nil];
        
        [YYYHttpTool post:YYYSubMediaAddURL params:prameters success:^(id json) {
            
            _subMediaDic = json;
            self.TextViewInput.text = @"";
            [self.TextViewInput resignFirstResponder];
            _subCommentView.frame = CGRectMake(0, self.view.frame.size.height - 40, kScreenWidth, 40);
            self.next = _subMediaDic[@"next"];
            self.subCommentPage = _subMediaDic[@"page"];
            [_subMediaList removeAllObjects];
            [_cellSelecArray removeAllObjects];
            for (NSDictionary *subComent in _subMediaDic[@"mediaList"]) {
                [_subMediaList addObject:subComent];
                [_cellSelecArray addObject:@"0"];
            }
            [_tableview reloadData];
            
        } failure:^(NSError *error) {
            TSLog(@"Hey Man");
        }];
    }
    _subCommentView.frame = CGRectMake(0, self.view.frame.size.height - 40 - 64, kScreenWidth, 40);
}

#pragma mark AlertView监听方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //进入登陆界面
        YYYLoginViewController *loginVC = [[YYYLoginViewController alloc] init];
        loginVC.registState = NO;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark 获取键盘高度
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfoDic = [aNotification userInfo];
    
    //动画持续时间
    double duration = [userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //键盘的frame
    CGRect keyboardF = [userInfoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    float offset = self.view.frame.size.height - 40 - keyboardF.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        _subCommentView.frame = CGRectMake(0, offset, self.view.frame.size.width, 40);
    }];
}

#pragma mark 评论解码
- (NSString *)decodeFromHTML:(NSArray *)array
{
    NSString *coment = [array componentsJoinedByString:@"\n"];
    
    coment = [coment stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    coment = [coment stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    coment = [coment stringByReplacingOccurrencesOfString:@"&#92;" withString:@"\\"];
    
    return coment;
}

#pragma mark 评论解码(评论子评论的评论)
- (NSString *)subDecodeFromHTML:(NSArray *)array Row:(NSInteger)row
{
    NSString *coment = [array componentsJoinedByString:@"\n"];
    
    coment = [coment stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    coment = [coment stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    coment = [coment stringByReplacingOccurrencesOfString:@"&#92;" withString:@"\\"];
    
    coment = [NSString stringWithFormat:@"回复%@: %@",_subMediaList[row][@"reUserName"],coment];
    
    return coment;
}

#pragma mark 头像缩放
- (UIImage *)scaleImageSize:(CGSize)size image:(UIImageView *)imageView
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    [imageView.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaleImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

//
//  URL.h
//  yyy
//
//  Created by TangXing on 15/11/17.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#ifndef URL_h
#define URL_h

#define YYYBaseURL @"http://103.123.80.107/yiyinyueapp/"

//验证码取得
#define YYYVeriCodeGetURL YYYBaseURL@"veri_code_get.do"
//加载视频相关数据
#define YYYLoadVideoURL YYYBaseURL@"video_view.do"
//加载歌单视频
#define YYYLoadPlaylistURL YYYBaseURL@"playlist_view.do"
//加载首页相关数据
#define YYYLoadHomeURL YYYBaseURL@"home_view.do"
//登录
#define YYYLoginURL YYYBaseURL@"login.do"
//评论视频。回复视频评论。评论歌单
#define YYYMediaAddURL YYYBaseURL@"media_add.do"
//加载更多评论
#define YYYMediaPagingURL YYYBaseURL@"media_paging.do"
//视频点赞
#define YYYMediaSupportURL YYYBaseURL@"media_support.do"
//视频举报
#define YYYMediaReportURL YYYBaseURL@"media_report.do"
//视频添加回复
#define YYYSubMediaAddURL YYYBaseURL@"sub_media_add.do"
//视频子回复
#define YYYSubMediaPagingURL YYYBaseURL@"sub_media_paging.do"
//视频回复支持数
#define YYYSubMediaSupportURL YYYBaseURL@"sub_media_support.do"
//视频收藏添加
#define YYYFavoriteAddURL YYYBaseURL@"video_favorite_add.do"
//视频点赞添加
#define YYYLikeAddURL YYYBaseURL@"video_like_add.do"
//用户添加关注
#define YYYFollowAddURL YYYBaseURL@"user_follow_add.do"
//用户取消关注`
#define YYYFollowCancelURL YYYBaseURL@"user_follow_cancel.do"
//播放数添加
#define YYYPlayCountAddURL YYYBaseURL@"play_count_add.do"
//歌单首页
#define YYYPlaylisthomeURL YYYBaseURL@"playlist_home_view.do"
//MV首页
#define YYYMVhomeURL YYYBaseURL@"mv_home_view.do"
//热门视频关键字取得
#define YYYHotSearchURL YYYBaseURL@"hot_search_keyword_get.do"
//补充视频关键字取得
#define YYYCompletedSearchURL YYYBaseURL@"completed_search_keyword_get.do"
//搜索
#define YYYSearch YYYBaseURL@"search.do"
//用户首页
#define YYYUserHomeView YYYBaseURL@"user_home_view.do"
//用户信息取得
#define YYYUserInfoGetURL YYYBaseURL@"user_info_get.do"
//用户头像编辑
#define YYYUserPhotoEditURL YYYBaseURL@"user_photo_edit.do"
//用户密码编辑
#define YYYUserPsdEditURL YYYBaseURL@"user_password_edit.do"
//用户性别编辑
#define YYYUserGenderEditURL YYYBaseURL@"user_gender_edit.do"
//用户姓名编辑
#define YYYUserNameEditURL YYYBaseURL@"user_name_edit.do"
//用户生日编辑
#define YYYUserBirthdayURL YYYBaseURL@"user_birthday_edit.do"
//用户收藏取得
#define YYYUserFavoriteURL YYYBaseURL@"user_favorite_paging.do"
//用户关注取得
#define YYYUserFollowURL YYYBaseURL@"user_follow_paging.do"
//用户消息取得
#define YYYUserNoticeURL YYYBaseURL@"user_notice_paging.do"
//用户私信取得
#define YYYUserLetterURL YYYBaseURL@"user_letter_paging.do"
//用户私信未读更新为已读
#define YYYUserLetterUpdataToReaded YYYBaseURL@"user_letter_updata_to_readed.do"
//用户私信添加
#define YYYUserLetterAddContent YYYBaseURL@"user_letter_add_content.do"
//系统通知取得
#define YYYSystemNoticeURL YYYBaseURL@"system_notice_paging.do"
//系统私信未读更新为已读
#define YYYSystemLetterUpdataToReaded YYYBaseURL@"system_letter_updata_to_readed.do"
//回复我的取得
#define YYYReplyMineURL YYYBaseURL@"reply_mine_paging.do"
//回复我的未读更新为已读
#define YYYReplyMineUpdataToReaded YYYBaseURL@"reply_mine_updata_to_readed.do"

#endif /* URL_h */

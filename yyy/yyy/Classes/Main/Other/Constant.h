//
//  Constant.h
//  yyy
//
//  Created by TangXing on 16/3/2.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#pragma mark 歌单排序区分
/**
 *  一页显示最大数
 */
#define VIEW_MAX_COUNT 10

/**
 *  歌单排序区分
 */
//歌单排序区分,时间
#define PLAYLIST_SORT_TIME @"01"
//歌单排序区分,收藏
#define PLAYLIST_SORT_FAVORITE_COUNT @"02"
//歌单排序区分,点赞
#define PLAYLIST_SORT_LIKE_COUNT @"03"

#pragma mark 视频排序区分
/**
 *  视频排序区分
 */
//视频排序区分,时间
#define VIDEO_SORT_TIME @"01"
//视频排序区分,收藏
#define VIDEO_SORT_FAVORITE_COUNT @"02"
//视频排序区分,点赞
#define VIDEO_SORT_LIKE_COUNT @"03"
//视频排序区分,播放
#define VIDEO_SORT_PLAY_COUNT @"04"

#pragma mark 搜索区分
/**
 *  搜索区分
 */
//搜索区分,视频
#define SEARCH_DIV_VIDEO @"01"
//搜索区分,歌单
#define SEARCH_DIV_PLAYLIST @"02"
//搜索区分,音乐人
#define SEARCH_DIV_MUSICAL @"03"
//搜索区分,乐队组合
#define SEARCH_DIV_BAND @"04"

#pragma mark 性别区分
/**
 *  性别区分
 */
//性别区分,不明
#define GENDER_UNKNOW @"0"
//性别区分,男性
#define GENDER_MALE @"1"
//性别区分,女性
#define GENDER_FEMALE @"2"

#pragma mark 收藏区分
/**
 *  收藏区分
 */
//收藏区分,视频
#define FAVORITE_DIV_VIDEO @"01"
//收藏区分,歌单
#define FAVORITE_DIV_PLAYLIST @"02"

#pragma mark 媒体区分
/**
 *  媒体区分
 */
//媒体区分,视频
#define MEDIA_DIV_VIDEO @"01"
//媒体区分,歌单
#define MEDIA_DIV_PLAYLIST @"02"
//媒体区分,留言
#define MEDIA_DIV_USER @"03"

#endif /* Constant_h */

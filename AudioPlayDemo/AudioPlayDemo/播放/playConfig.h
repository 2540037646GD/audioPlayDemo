//
//  playConfig.h
//  AudioPlayDemo
//
//  Created by guodongZhang on 2024/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface playConfig : NSObject
//自动播放
@property (nonatomic,assign) BOOL isAutoPlay;
//播放地址
@property (copy, nonatomic) NSString *url;
//专辑标题
@property (copy, nonatomic) NSString *albumTitle;
//专辑
@property (copy, nonatomic) NSString *albumArtist;
//音频名称
@property (copy, nonatomic) NSString *albumItemTitle;
//专辑封面图
@property (copy, nonatomic) NSString *albumCoverImage;
//当前播放进度秒
@property (nonatomic,assign) double current;
//总时长秒
@property (nonatomic,assign) double duration;
@end

NS_ASSUME_NONNULL_END

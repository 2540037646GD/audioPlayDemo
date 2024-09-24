//
//  AudioPlayUtil.h
//  AudioPlayDemo
//
//  Created by guodongZhang on 2024/9/4.
//

#import <Foundation/Foundation.h>
#import "playConfig.h"

NS_ASSUME_NONNULL_BEGIN



@interface AudioPlayUtil : NSObject

+ (AudioPlayUtil*)sharedInstance;

- (void)initPlayerWithAudioInfo:(playConfig *)audioInfo;


@property (copy, nonatomic) void (^audioProgressUpdate)(NSMutableDictionary * diction);
@property (copy, nonatomic) void (^playerCompletion)(void);
@property (copy, nonatomic) void (^playNext)(void);
@property (copy, nonatomic) void (^playUper)(void);

//暂停播放
- (void)audioPause;
//开始播放
- (void)audioPlay;
//回退(15)秒
- (void)QuickretreatWithTime:(NSInteger )miao;
//快进(15)秒
- (void)FastforwardWithTime:(NSInteger)miao;

//设置播放进度
- (void)setToTime:(NSInteger)time;

//设置播放倍速
- (void)settingPlayRate:(float)rate;
@end

NS_ASSUME_NONNULL_END

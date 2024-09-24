//
//  AudioPlayUtil.m
//  AudioPlayDemo
//
//  Created by guodong-zhang on 2024/9/4.
//

#import "AudioPlayUtil.h"
#import "AVFoundation/AVPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

static AudioPlayUtil *audioPlayUtil = nil;

@interface AudioPlayUtil ()

@property(nonatomic,assign) id timeObserve;
@property(nonatomic,strong) AVPlayer *player;
@property (nonatomic,assign) BOOL isPlay;
@property (strong, nonatomic) playConfig *config;
//倍速
@property (nonatomic,assign) float rate;
@end

@implementation AudioPlayUtil

+ (AudioPlayUtil*)sharedInstance {
    @synchronized(self) {
        if(!audioPlayUtil) {
            audioPlayUtil = [[self alloc] init];
            audioPlayUtil.rate = 1;
        }
    }
    return audioPlayUtil;
}

- (void)initPlayerWithAudioInfo:(playConfig *)audioInfo{
    if (!audioInfo) {
        NSLog(@"数据错误");
        return;
    }
    self.config = audioInfo;
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    NSURL * url  = [NSURL URLWithString:audioInfo.url];
    AVPlayerItem * songItem = [[AVPlayerItem alloc] initWithURL:url];
    [songItem seekToTime:CMTimeMake(self.config.current, 1)];
    [self.player replaceCurrentItemWithPlayerItem:songItem];
    [self setPlayingCenter];
    if (self.config.isAutoPlay) {
        [self audioPlay];
    }else{
        [self audioPause];
    }
    __block AudioPlayUtil *wself = self;
    self.timeObserve  = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = (CMTimeGetSeconds(wself.player.currentItem.duration));
        if (total > 0) {
            wself.config.current = current;
            [wself setLockProgress:current];
            float progress = current / total;
            NSMutableDictionary *diction = [NSMutableDictionary dictionary];
            diction[@"total"] = @(total);
            diction[@"current"] = @(current);
            if (wself.audioProgressUpdate) {
                wself.audioProgressUpdate(diction);
            }
            if (progress == 1){
                if (wself.playerCompletion) {
                    wself.playerCompletion();
                }
            }
            
        }
    }];
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    AudioSessionSetActive(true);
    
    
}


- (void)audioPause{
    [self.player pause];
    self.isPlay = NO;
}
- (void)audioPlay{
    [self.player play];
    self.isPlay = YES;
}
- (void)setLockProgress:(NSInteger)current{
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *nowPlayingInfo = [NSMutableDictionary dictionaryWithDictionary:center.nowPlayingInfo];
    [nowPlayingInfo setObject:[NSNumber numberWithDouble:current] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    center.nowPlayingInfo = nowPlayingInfo;
}
//退回多少秒
- (void)QuickretreatWithTime:(NSInteger )miao{
    float time = self.player.currentItem.currentTime.value/self.player.currentItem.currentTime.timescale - miao >= 0 ? self.player.currentItem.currentTime.value/self.player.currentItem.currentTime.timescale - miao:0;
    [self.player.currentItem seekToTime:CMTimeMakeWithSeconds(time, self.player.currentItem.currentTime.timescale)];
    [self setLockProgress:time];
    
}
//快进多少秒
- (void)FastforwardWithTime:(NSInteger)miao{
    float time = self.player.currentItem.currentTime.value/self.player.currentItem.currentTime.timescale + miao <= self.player.currentItem.currentTime.timescale ? self.player.currentItem.currentTime.value/self.player.currentItem.currentTime.timescale + miao:self.player.currentItem.currentTime.timescale;
    [self.player.currentItem seekToTime:CMTimeMakeWithSeconds(time, self.player.currentItem.currentTime.timescale) toleranceBefore:CMTimeMake(1, self.player.currentItem.currentTime.timescale) toleranceAfter:CMTimeMake(1, self.player.currentItem.currentTime.timescale)];
    [self setLockProgress:time];

}
//设置播放进度
- (void)setToTime:(NSInteger)time{
    [self.player.currentItem seekToTime:CMTimeMakeWithSeconds(time, 1)];
    [self setLockProgress:time];
}
//设置播放倍速
- (void)settingPlayRate:(float)rate{
    self.player.rate = rate;
    self.rate = rate;
    if (!self.isPlay) {
        [self.player pause];
    }
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *nowPlayingInfo = [NSMutableDictionary dictionaryWithDictionary:center.nowPlayingInfo];
    [nowPlayingInfo setObject:[NSNumber numberWithFloat:self.rate] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    center.nowPlayingInfo = nowPlayingInfo;
}




                   
- (void)setPlayingCenter{
    if ([[[MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo objectForKey:MPMediaItemPropertyTitle]  isEqualToString:self.config.albumItemTitle]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.config.albumCoverImage]]]];
        NSMutableDictionary *nowPlayingInfo = [NSMutableDictionary dictionary];
        [nowPlayingInfo setObject:self.config.albumItemTitle forKey:MPMediaItemPropertyTitle];
        [nowPlayingInfo setObject:self.config.albumArtist forKey:MPMediaItemPropertyArtist];
        [nowPlayingInfo setObject:self.config.albumTitle forKey:MPMediaItemPropertyAlbumTitle];
        [nowPlayingInfo setObject:artwork forKey:MPMediaItemPropertyArtwork];
        [nowPlayingInfo setObject:[NSNumber numberWithFloat:self.rate] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        [nowPlayingInfo setObject:[NSNumber numberWithDouble:self.config.current] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [nowPlayingInfo setObject:[NSNumber numberWithDouble:self.config.duration] forKey:MPMediaItemPropertyPlaybackDuration];
        dispatch_async(dispatch_get_main_queue(), ^{
            center.nowPlayingInfo = nowPlayingInfo;
        });
    });
    

}

- (AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

@end

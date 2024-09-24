//
//  ViewController.m
//  AudioPlayDemo
//
//  Created by guodongZhang on 2024/9/24.
//

#import "ViewController.h"

#import "AudioPlayUtil.h"
@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *array;
@property (nonatomic,assign) NSInteger index;
@property (strong, nonatomic) AudioPlayUtil *audioUtil;
@property (strong, nonatomic) UIButton *bfBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    ///一下代码随便写的,
    UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 60, 30)];
    [self.view addSubview:b1];
    [b1 setTitle:@"上一首" forState:0];
    b1.backgroundColor = UIColor.redColor;
    [b1 addTarget:self action:@selector(shangyishou) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *b2 = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 60, 30)];
    [self.view addSubview:b2];
    [b2 setTitle:@"播放" forState:0];
    [b2 setTitle:@"暂停" forState:UIControlStateSelected];
    b2.backgroundColor = UIColor.redColor;
    [b2 addTarget:self action:@selector(bofang:) forControlEvents:UIControlEventTouchUpInside];
    self.bfBtn = b2;
    
    UIButton *b3 = [[UIButton alloc] initWithFrame:CGRectMake(300, 100, 60, 30)];
    [self.view addSubview:b3];
    [b3 setTitle:@"下一首" forState:0];
    b3.backgroundColor = UIColor.redColor;
    [b3 addTarget:self action:@selector(xiayishou) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *b4 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 60, 30)];
    [self.view addSubview:b4];
    [b4 setTitle:@"退15秒" forState:0];
    b4.backgroundColor = UIColor.redColor;
    [b4 addTarget:self action:@selector(houtui15miao) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *b5 = [[UIButton alloc] initWithFrame:CGRectMake(300, 200, 60, 30)];
    [self.view addSubview:b5];
    [b5 setTitle:@"进15秒" forState:0];
    b5.backgroundColor = UIColor.redColor;
    [b5 addTarget:self action:@selector(kuaijin15miao) forControlEvents:UIControlEventTouchUpInside];
    
   
    [self initData];
    
    AudioPlayUtil *util = [AudioPlayUtil sharedInstance];
    
    util.audioProgressUpdate = ^(NSMutableDictionary * _Nonnull diction) {
        NSLog(@"播放进度%@---总时长%@",diction[@"current"],diction[@"total"]);
    };
    util.playerCompletion = ^{
        //播放完成
        [self xiayishou];
    };
    util.playNext = ^{
        [self xiayishou];
    };
    util.playUper = ^{
        [self shangyishou];
    };
    self.audioUtil = util;
    
    //默认播放第一个
    [self bofangAudio];
}

- (void)houtui15miao{
    [[AudioPlayUtil sharedInstance] QuickretreatWithTime:15];
}
- (void)kuaijin15miao{
    [[AudioPlayUtil sharedInstance] FastforwardWithTime:15];
}
- (void)bofang:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.audioUtil audioPlay];
    }else{
        [self.audioUtil audioPause];
    }
    
}

- (void)shangyishou{
    self.index --;
    if (self.index < 0) {
        self.index = 0;
    }
    [self bofangAudio];
}

- (void)xiayishou{
    self.index++;
    if (self.index >= self.array.count) {
        self.index = 0;
    }
    [self bofangAudio];
}

- (void)bofangAudio{
    self.bfBtn.selected = YES;
    playConfig *config = self.array[self.index];
    [[AudioPlayUtil sharedInstance] initPlayerWithAudioInfo:config];
}

- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)initData{
    playConfig *config = [[playConfig alloc] init];
    config.isAutoPlay = YES;
    config.url = @"https://lion-prod-1318118438.cos.ap-beijing.myqcloud.com/audio/2023-08/2023-08-02/6c83e3fb3d944ef4be68d08f1debe89a.mp3";
    config.albumTitle = @"水浒发刊词 听108位英雄的豪情侠义！";
    config.albumItemTitle = @"水浒发刊词 听108位英雄的豪情侠义！";
    config.albumCoverImage = @"https://lion-prod-1318118438.cos.ap-beijing.myqcloud.com/image/2023-08/2023-08-07/e3c2d4971ceb48719d9ad50a14dbed4b.jpg";
    config.albumArtist = @"作者:狮子老爸";
    config.current = 0;
    config.duration = 647.0;
    [self.array addObject:config];
    
    playConfig *config2 = [[playConfig alloc] init];
    config2.isAutoPlay = YES;
    config2.url = @"https://lion-prod-1318118438.cos.ap-beijing.myqcloud.com/audio/2023-07/2023-07-30/3d987aef38fc496cae8b0a5e8b8ea4ca.mp3";
    config2.albumTitle = @"水浒发刊词 听108位英雄的豪情侠义！";
    config2.albumItemTitle = @"水浒传 001 瘟疫蔓延 民不聊生";
    config2.albumCoverImage = @"https://lion-prod-1318118438.cos.ap-beijing.myqcloud.com/image/2023-08/2023-08-07/e3c2d4971ceb48719d9ad50a14dbed4b.jpg";
    config2.albumArtist = @"作者:狮子老爸";
    config2.current = 0;
    config2.duration = 1944.0;
    [self.array addObject:config2];
    
    
    playConfig *config3 = [[playConfig alloc] init];
    config3.isAutoPlay = YES;
    config3.url = @"https://lion-prod-1318118438.cos.ap-beijing.myqcloud.com/audio/2023-07/2023-07-30/bed56571edc54814a65a56101e62abf4.mp3";
    config3.albumTitle = @"水浒发刊词 听108位英雄的豪情侠义！";
    config3.albumItemTitle = @"水浒传 002 皇帝降旨 请张天师";
    config3.albumCoverImage = @"https://lion-prod-1318118438.cos.ap-beijing.myqcloud.com/image/2023-08/2023-08-07/e3c2d4971ceb48719d9ad50a14dbed4b.jpg";
    config3.albumArtist = @"作者:狮子老爸";
    config3.current = 0;
    config3.duration = 289.0;
    [self.array addObject:config3];
}
@end

//
//  AppDelegate+audio.m
//  AudioPlayDemo
//
//  Created by guodongZhang on 2024/9/24.
//

#import "AppDelegate+audio.h"
#import "AudioPlayUtil.h"
@implementation AppDelegate (audio)

- (void)setLockPlay{
    [[UIApplication  sharedApplication] beginReceivingRemoteControlEvents];
    [self  becomeFirstResponder];
}

- (void)beginReceivingRemoteControlEvents {
    [self becomeFirstResponder];
}
-  (BOOL)canBecomeFirstResponder
{
    return  YES;
}
-  (void)remoteControlReceivedWithEvent:(UIEvent  *)receivedEvent  {

    if  (receivedEvent.type  ==  UIEventTypeRemoteControl)  {

        switch  (receivedEvent.subtype)  {

            case UIEventSubtypeRemoteControlTogglePlayPause:
                [[AudioPlayUtil sharedInstance] audioPause];
                break;

            case UIEventSubtypeRemoteControlNextTrack:

                if ([AudioPlayUtil sharedInstance].playNext) {
                    [AudioPlayUtil sharedInstance].playNext();
                }
                break;

            case UIEventSubtypeRemoteControlPreviousTrack:
                if ([AudioPlayUtil sharedInstance].playUper) {
                    [AudioPlayUtil sharedInstance].playUper();
                }
                break;
                
            case UIEventSubtypeRemoteControlPlay:
                [[AudioPlayUtil sharedInstance] audioPlay];
                break;
                
            case UIEventSubtypeRemoteControlPause:
                [[AudioPlayUtil sharedInstance] audioPause];
                break;
            default:
                break;

        }

    }
    
}
@end

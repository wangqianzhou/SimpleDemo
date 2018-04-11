//
//  ViewController.m
//  SimpleDemo
//
//  Created by wangqianzhou on 13-12-15.
//  Copyright (c) 2013年 wangqianzhou. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import "UIView+Addtions.h"
#import <AgoraAudioKit/AgoraRtcEngineKit.h>

const int cstBtnHeight = 80;
const int cstBtnWidth  = 100;

NSString* const kAgoraRtcAppKey = @"";

@interface ViewController ()<AgoraRtcEngineDelegate>
@property(nonatomic, strong)AgoraRtcEngineKit* sharedEngine;
@property(nonatomic, strong)UILabel* usersLabel;
@property(nonatomic, strong)NSMutableSet* channelUsers;
@property(nonatomic, assign)NSInteger myId;
@end

@implementation ViewController
- (void)loadView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    UIView* mainView = [[UIView alloc] initWithFrame:screen];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    self.view = mainView;
    
    _usersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, 80)];
    _usersLabel.numberOfLines = 2;
    [self.view addSubview:_usersLabel];
    
    UIButton* btnJoinChannel = [self buttonWithTitle:@"Join"];
    btnJoinChannel.top = 0;
    btnJoinChannel.left = 0;
    btnJoinChannel.tag = 0;
    
    UIButton* btnLeaveChannel = [self buttonWithTitle:@"Leave"];
    btnLeaveChannel.right = self.view.right;
    btnLeaveChannel.top = 0;
    btnLeaveChannel.tag = 1;
    
    UIButton* btnExit = [self buttonWithTitle:@"Exit"];
    btnExit.bottom = self.view.bottom;
    btnExit.left = 0;
    btnExit.tag = 2;

    UIButton* btnTest = [self buttonWithTitle:@"Test"];
    btnTest.bottom = self.view.bottom;
    btnTest.right = self.view.right;
    btnTest.tag = 2;
    
    self.channelUsers = [NSMutableSet set];
}

- (UIButton*)buttonWithTitle:(NSString*)title
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState: UIControlStateNormal];
    [btn setTitle:title forState: UIControlStateHighlighted];
    
    btn.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.8];
    
    CGRect frame = CGRectMake(0, 0, cstBtnWidth, cstBtnHeight);
    btn.frame = frame;
    
    [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn];
    
    return btn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupEngine];
}

- (void)setupEngine
{
    _sharedEngine = [AgoraRtcEngineKit sharedEngineWithAppId:kAgoraRtcAppKey delegate:self];
    NSLog(@"AgoraRtcEngine version %@: ", [AgoraRtcEngineKit getSdkVersion]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return 0;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark- Functions
- (void)onBtnClick:(UIButton*)sender
{
    if (sender.tag == 0) {
        self.myId = arc4random();
        [self updateUserList];
        [_sharedEngine joinChannelByToken:kAgoraRtcAppKey channelId:@"MyDemoChannel" info:nil uid:self.myId joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
            [_sharedEngine setEnableSpeakerphone:YES];
            NSLog(@"Join Channel success...");
        }];
    } else if (sender.tag == 1) {
        [_sharedEngine leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
            NSLog(@"Leave Channel, current channel state: %@", stat);
            [self clearAllUser];
        }];
    } else if (sender.tag == 2) {
        exit(0);
    } else if (sender.tag == 3) {
        // Do Test
    }
}

- (void)addUser:(NSInteger)uid
{
    [self.channelUsers addObject:@(uid)];
    [self updateUserList];
}

- (void)removeUser:(NSInteger)uid
{
    [self.channelUsers removeObject:@(uid)];
    [self updateUserList];
}

- (void)clearAllUser
{
    self.myId = 0;
    [self.channelUsers removeAllObjects];
    [self updateUserList];
}

- (void)updateUserList
{
    NSMutableString* list = [NSMutableString stringWithFormat:@"my : %@\nuser: ", @(self.myId)];
    [self.channelUsers enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [list appendString:[NSString stringWithFormat:@"%@; ", obj]];
    }];
    
    self.usersLabel.text = list;
}
#pragma mark- AgoraRtcEngineDelegate
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOccurWarning:(AgoraWarningCode)warningCode
{
    
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOccurError:(AgoraErrorCode)errorCode
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngineMediaEngineDidLoaded:(AgoraRtcEngineKit * _Nonnull)engine
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngineMediaEngineDidStartCall:(AgoraRtcEngineKit * _Nonnull)engine
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngineRequestToken:(AgoraRtcEngineKit * _Nonnull)engine
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngineConnectionDidInterrupted:(AgoraRtcEngineKit * _Nonnull)engine
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit * _Nonnull)engine
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngineConnectionDidBanned:(AgoraRtcEngineKit * _Nonnull)engine
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
//- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine reportRtcStats:(AgoraChannelStats * _Nonnull)stats
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
//- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine lastmileQuality:(AgoraNetworkQuality)quality
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
//- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didApiCallExecute:(NSInteger)error api:(NSString * _Nonnull)api result:(NSString * _Nonnull)result;
//{
//    NSLog(@"%s : %@", __PRETTY_FUNCTION__, api);
//}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didRefreshRecordingServiceStatus:(NSInteger)status;
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
#pragma mark Local user common delegates

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didJoinChannel:(NSString * _Nonnull)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didRejoinChannel:(NSString * _Nonnull)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didClientRoleChanged:(AgoraClientRole)oldRole newRole:(AgoraClientRole)newRole
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didLeaveChannelWithStats:(AgoraChannelStats * _Nonnull)stats
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
//- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine networkQuality:(NSUInteger)uid txQuality:(AgoraNetworkQuality)txQuality rxQuality:(AgoraNetworkQuality)rxQuality
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
#pragma mark Local user audio delegates

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine firstLocalAudioFrame:(NSInteger)elapsed
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didAudioRouteChanged:(AgoraAudioOutputRouting)routing
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngineLocalAudioMixingDidFinish:(AgoraRtcEngineKit * _Nonnull)engine
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngineDidAudioEffectFinish:(AgoraRtcEngineKit * _Nonnull)engine soundId:(NSInteger)soundId
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark Local user video delegates

- (void)rtcEngineCameraDidReady:(AgoraRtcEngineKit * _Nonnull)engine
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine cameraFocusDidChangedToRect:(CGRect)rect
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngineVideoDidStop:(AgoraRtcEngineKit * _Nonnull)engine
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine localVideoStats:(AgoraRtcLocalVideoStats * _Nonnull)stats
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
#pragma mark Remote user common delegates

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    [self addUser:uid];
    NSLog(@"%s uid: %@, elapsed: %@", __PRETTY_FUNCTION__, @(uid), @(elapsed));
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason
{
    [self removeUser:uid];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine receiveStreamMessageFromUid:(NSUInteger)uid streamId:(NSInteger)streamId data:(NSData * _Nonnull)data
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOccurStreamMessageErrorFromUid:(NSUInteger)uid streamId:(NSInteger)streamId error:(NSInteger)error missed:(NSInteger)missed cached:(NSInteger)cached
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
#pragma mark Remote user audio delegates


- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine firstRemoteAudioFrameOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didAudioMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine reportAudioVolumeIndicationOfSpeakers:(NSArray<AgoraRtcAudioVolumeInfo *> * _Nonnull)speakers totalVolume:(NSInteger)totalVolume
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine activeSpeaker:(NSUInteger)speakerUid
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngineRemoteAudioMixingDidStart:(AgoraRtcEngineKit * _Nonnull)engine
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngineRemoteAudioMixingDidFinish:(AgoraRtcEngineKit * _Nonnull)engine
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine audioQualityOfUid:(NSUInteger)uid quality:(AgoraNetworkQuality)quality delay:(NSUInteger)delay lost:(NSUInteger)lost
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, @(uid));
}

#pragma mark Remote user video delegates
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine firstRemoteVideoFrameOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine videoSizeChangedOfUid:(NSUInteger)uid size:(CGSize)size rotation:(NSInteger)rotation
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didVideoEnabled:(BOOL)enabled byUid:(NSUInteger)uid
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didLocalVideoEnabled:(BOOL)enabled byUid:(NSUInteger)uid
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine remoteVideoStats:(AgoraRtcRemoteVideoStats * _Nonnull)stats
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine streamPublishedWithUrl:(NSString * _Nonnull)url errorCode:(AgoraErrorCode)errorCode
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine streamUnpublishedWithUrl:(NSString * _Nonnull)url
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngineTranscodingUpdated:(AgoraRtcEngineKit * _Nonnull)engine
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine publishingRequestReceivedFromUid:(NSUInteger)uid
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine publishingRequestAnsweredByOwner:(NSUInteger)uid accepted:(BOOL)accepted error:(AgoraErrorCode)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine unpublishingRequestReceivedFromOwner:(NSUInteger)uid
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine streamInjectedStatusOfUrl:(NSString * _Nonnull)url uid:(NSUInteger)uid status:(AgoraInjectStreamStatus)status
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end

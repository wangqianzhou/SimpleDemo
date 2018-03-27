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

const int cstBtnHeight = 100;
const int cstBtnWidth  = 200;

@interface ViewController ()<AgoraRtcEngineDelegate>
@property(nonatomic, strong)UIButton* btn;
@property(nonatomic, strong)AgoraRtcEngineKit* sharedEngine;
@end

@implementation ViewController
- (void)loadView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    UIView* mainView = [[UIView alloc] initWithFrame:screen];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    self.view = mainView;
    
    _btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btn setTitle:@"ClickMe" forState: UIControlStateNormal];
    [_btn setTitle:@"ClickMe" forState: UIControlStateHighlighted];
    
    float x = (screen.size.width - cstBtnWidth) / 2.0f;
    float y = (screen.size.height - cstBtnHeight) / 2.0f;
    _btn.frame = CGRectMake(x, y, cstBtnWidth, cstBtnHeight);
    _btn.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:_btn];
}

- (void)dealloc
{
    [_btn removeTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventAllEvents];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _sharedEngine = [AgoraRtcEngineKit sharedEngineWithAppId:@"6e71ab7ff3f94358b2b7e416afc18979" delegate:self];
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
- (void)onBtnClick:(id)sender
{
    [_sharedEngine joinChannelByToken:nil channelId:@"demoChannel" info:nil uid:0 joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        [_sharedEngine setEnableSpeakerphone:YES];
    }];
}

#pragma mark- AgoraRtcEngineDelegate

@end

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
#import <ifaddrs.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

const int cstBtnHeight = 100;
const int cstBtnWidth  = 200;

@interface ViewController ()
@property(nonatomic, strong)UIButton* btn;
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
    NSLog(@"\n%@", [[self class] getIpAddresses]);
}

+ (NSDictionary *)getIpAddresses {
    NSMutableDictionary* addresses = [[NSMutableDictionary alloc] init];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    // retrieve the current interfaces - returns 0 on success
    NSInteger success = getifaddrs(&interfaces);
    //NSLog(@"%@, success=%d", NSStringFromSelector(_cmd), success);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Get NSString from C String
                NSString* ifaName = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString* address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_addr)->sin_addr)];
                NSString* mask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_netmask)->sin_addr)];
                NSString* gateway = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_dstaddr)->sin_addr)];
                
                NSDictionary* netAddress = @{
                                             @"name": ifaName,
                                             @"address": address,
                                             @"netmask": mask,
                                             @"gateway": gateway,
                                             };
                
                addresses[ifaName] = netAddress;
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    return addresses;
}
@end

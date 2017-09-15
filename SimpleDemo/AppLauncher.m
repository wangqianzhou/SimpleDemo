//
//  AppLauncher.m
//  SimpleDemo
//
//  Created by wangqianzhou on 14/09/2017.
//  Copyright © 2017 wangqianzhou. All rights reserved.
//

#import "AppLauncher.h"
#import <objc/message.h>

@implementation AppLauncher
+ (void)run
{
    [self setupPastboard];
    [self wakeupApplicationWithBundle:@"com.ucweb.iphone.dev"];
    
    exit(0);
}

+ (void)wakeupApplicationWithBundle:(NSString*)bundleID
{
    id workspaceClass = NSClassFromString(@"LSApplicationWorkspace");
    SEL instanceSEL = NSSelectorFromString(@"defaultWorkspace");
    SEL openSEL = NSSelectorFromString(@"openApplicationWithBundleID:");
    
    id instance = ((id(*)(id, SEL))objc_msgSend)(workspaceClass, instanceSEL);
    BOOL result = ((BOOL(*)(id, SEL, id))objc_msgSend)(instance, openSEL, bundleID);
    
    NSLog(@"Open %@ with result : %zd", bundleID, result);
}

+ (void)setupPastboard
{
    UIPasteboard* paste = [UIPasteboard generalPasteboard];
    
    NSString* pastboardType = @"CaveManKey";
    
    NSMutableDictionary* myDictionary = [NSMutableDictionary dictionary];
    [myDictionary setValue:@"https://m.baidu.com" forKey:@"url"];
    
    NSDictionary* config = @{
                             @"callback_bundle_id" : [[NSBundle mainBundle] bundleIdentifier],
                             @"ignore_test_result" : @(1),
                             @"clearCache" : @(1)
                             };
    
    
    [myDictionary setValue:@{@"case_config" : config} forKey:@"task"];
    
    NSData* pastboardData = [NSKeyedArchiver archivedDataWithRootObject:myDictionary];
    
    NSDictionary* item = @{pastboardType : pastboardData};
    
    paste.items = @[item];
}

@end

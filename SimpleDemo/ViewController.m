//
//  ViewController.m
//  SimpleDemo
//
//  Created by wangqianzhou on 13-12-15.
//  Copyright (c) 2013年 wangqianzhou. All rights reserved.
//

#import "ViewController.h"
#import "QuadCurveMenu.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>

@interface ViewController ()<QuadCurveMenuDelegate, NSMachPortDelegate>
@property(nonatomic, retain)QuadCurveMenu* sysMenu;
@end

@implementation ViewController
- (void)loadView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    UIView* mainView = [[[UIView alloc] initWithFrame:screen] autorelease];
    [mainView setBackgroundColor:[UIColor grayColor]];
    self.view = mainView;
    
    [self initSysMenu];
}

- (void)dealloc
{
    [_sysMenu release], _sysMenu = nil;
    [super dealloc];
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

- (NSUInteger)supportedInterfaceOrientations
{
    return 0;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)initSysMenu
{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
    
    QuadCurveMenuItem *starMenuItem1 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem2 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem3 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem4 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem5 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem6 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem7 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem8 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5, starMenuItem6, starMenuItem7,starMenuItem8, nil];
    [starMenuItem1 release];
    [starMenuItem2 release];
    [starMenuItem3 release];
    [starMenuItem4 release];
    [starMenuItem5 release];
    [starMenuItem6 release];
    [starMenuItem7 release];
    [starMenuItem8 release];
    
    QuadCurveMenu *menu = [[[QuadCurveMenu alloc] initWithFrame:self.view.bounds menus:menus] autorelease];
	
	// customize menu
	/*
     menu.rotateAngle = M_PI/3;
     menu.menuWholeAngle = M_PI;
     menu.timeOffset = 0.2f;
     menu.farRadius = 180.0f;
     menu.endRadius = 100.0f;
     menu.nearRadius = 50.0f;
     */
	
    menu.delegate = self;
    
    [self.view addSubview:menu];
    self.sysMenu = menu;
}

#pragma mark- QuadCurveMenuDelegate
- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"onBtn_%d", idx]);
    objc_msgSend(self, sel);
}

#pragma mark-
#pragma mark- Functions
- (void)onBtn_0
{
    [NSThread detachNewThreadSelector:@selector(threadMain) toTarget:self withObject:nil];
}

- (void)onBtn_1
{
    [self launchThread];
}

- (void)onBtn_2
{
    
}

- (void)onBtn_3
{
    
}

- (void)onBtn_4
{
    
}

- (void)onBtn_5
{
    
}

- (void)onBtn_6
{
    
}

- (void)onBtn_7
{
    
}

#pragma mark-
#pragma mark- Other
- (void)threadMain
{
    NSThread* thread = [NSThread currentThread];
    [thread setName:@"CustomTimerThread"];
    
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    // The application uses garbage collection, so no autorelease pool is needed.
    NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
    [myRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
    
    NSPort* mPort = [[NSMachPort alloc] init];
    [mPort setDelegate:self];
    [myRunLoop addPort:mPort forMode:NSDefaultRunLoopMode];
   
    do 
    {
        NSAutoreleasePool* loopPool = [NSAutoreleasePool new];        
        [myRunLoop run];
        
        [loopPool release];
        
    } while (true);
    
    [pool release];
}

- (void)timerFunc
{
    static int i = 0;
    NSLog(@"Timer Func called %d times...", i++);
}

- (void)handleMachMessage:(void *)msg
{
    
}

- (void)launchThread
{
    NSPort* myPort = [NSMachPort port];
    if (myPort)
    {
        // This class handles incoming port messages.
        [myPort setDelegate:self];
        
        // Install the port as an input source on the current run loop.
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        
        // Detach the thread. Let the worker release the port.
        [NSThread detachNewThreadSelector:@selector(LaunchThreadWithPort:)
                                 toTarget:self withObject:myPort];

    }
}

- (void)LaunchThreadWithPort:(NSPort*)port
{
    NSThread* thread = [NSThread currentThread];
    [thread setName:@"PortThread"];

    
    NSAutoreleasePool*  pool = [[NSAutoreleasePool alloc] init];
    
    // Set up the connection between this thread and the main thread.
    NSPort* distantPort = port;
    
    ViewController*  workerObj = [[[self class] alloc] init];
    [workerObj sendCheckinMessage:distantPort];
    [distantPort release];
    
    // Let the run loop process things.
    do
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    }
    while (![workerObj shouldExit]);
    
    [workerObj release];
    [pool release];
}

- (void)sendCheckinMessage:(NSPort*)port
{
    
}

- (BOOL)shouldExit
{
    return NO;
}
@end

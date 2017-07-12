//
//  ViewController.m
//  SimpleDemo
//
//  Created by wangqianzhou on 13-12-15.
//  Copyright (c) 2013年 wangqianzhou. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <JavaScriptCore/JSExport.h>

@protocol TestObjExports <JSExport>
@property(nonatomic, retain, readwrite)NSString* pa;
@property(nonatomic, retain, readwrite)NSDictionary* pb;
- (instancetype)initWithParamA:(NSString*)a paramB:(NSDictionary*)b;

+ (instancetype)makeObj;
@end

@interface TestObj : NSObject<TestObjExports>
//JSExportAs(constructor,
- (instancetype)initWithParamA:(NSString*)a paramB:(NSDictionary*)b;
//           );
@end

@implementation TestObj
@synthesize pa = _pa;
@synthesize pb = _pb;
- (instancetype)initWithParamA:(NSString*)a paramB:(NSDictionary*)b;
{
    if (self = [super init])
    {
        _pa = [a retain];
        _pb = [b retain];
    }
    
    return self;
}

+ (instancetype)makeObj
{
    return [[[TestObj alloc] init] autorelease];
}

- (void)dealloc
{
    [super dealloc];
}

@end

const int cstBtnHeight = 100;
const int cstBtnWidth  = 200;

@interface ViewController ()
@property(nonatomic, retain)UIButton* btn;
@property(nonatomic, retain)JSContext* jsContext;
@end

@implementation ViewController
- (void)loadView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    UIView* mainView = [[[UIView alloc] initWithFrame:screen] autorelease];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    self.view = mainView;
    
    _btn = [[UIButton buttonWithType:UIButtonTypeSystem] retain];
    [_btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btn setTitle:@"ClickMe" forState: UIControlStateNormal];
    [_btn setTitle:@"ClickMe" forState: UIControlStateHighlighted];
    
    float x = (screen.size.width - cstBtnWidth) / 2.0f;
    float y = (screen.size.height - cstBtnHeight) / 2.0f;
    _btn.frame = CGRectMake(x, y, cstBtnWidth, cstBtnHeight);
    _btn.backgroundColor = [UIColor redColor];
    _jsContext = [[JSContext alloc] init];
    _jsContext.name = @"TestContext";
    
    _jsContext[@"Test"] = [TestObj class];
    
    [self.view addSubview:_btn];
}

- (void)dealloc
{
    [_jsContext release], _jsContext = nil;
    [_btn removeTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventAllEvents];
    [_btn release], _btn = nil;
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

}


@end

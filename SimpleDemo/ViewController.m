//
//  ViewController.m
//  SimpleDemo
//
//  Created by wangqianzhou on 13-12-15.
//  Copyright (c) 2013年 wangqianzhou. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import "CollectionViewCell.h"
#import "CollectionReusableView.h"

bool setProxy(NSString* host, NSUInteger port)
{
    SCPreferencesRef pref = SCPreferencesCreateWithAuthorization(kCFAllocatorDefault, CFSTR("PrettyTunnel"), NULL, NULL);
    
    if (pref) {
        NSLog(@"");
    }
    
    return true;
}

NSString* const kCellReuseIdentifier = @"kCellReuseIdentifier";
NSString* const kHeaderReuseIdentifier = @"kHeaderReuseIdentifier";

const int cstBtnHeight = 100;
const int cstBtnWidth  = 200;

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, retain)UIButton* btn;
@property(nonatomic, retain)UICollectionView* collectionView;
@end

@implementation ViewController
- (void)loadView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    UIView* mainView = [[[UIView alloc] initWithFrame:screen] autorelease];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    self.view = mainView;
    
//    _btn = [[UIButton buttonWithType:UIButtonTypeSystem] retain];
//    [_btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_btn setTitle:@"ClickMe" forState: UIControlStateNormal];
//    [_btn setTitle:@"ClickMe" forState: UIControlStateHighlighted];
//    
//    float x = (screen.size.width - cstBtnWidth) / 2.0f;
//    float y = (screen.size.height - cstBtnHeight) / 2.0f;
//    _btn.frame = CGRectMake(x, y, cstBtnWidth, cstBtnHeight);
//    _btn.backgroundColor = [UIColor redColor];
//    
//    [self.view addSubview:_btn];
    UICollectionViewFlowLayout* layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
    layout.itemSize = CGSizeMake(40, 40);
    layout.headerReferenceSize = CGSizeMake(0, 30);
    
    self.collectionView = [[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout] autorelease];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
    [self.collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderReuseIdentifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UIView* backgroundView = [[UIView alloc] initWithFrame:self.collectionView.bounds];
    backgroundView.backgroundColor = [UIColor grayColor];
    self.collectionView.backgroundView = backgroundView;
    
    [self.view addSubview:self.collectionView];

}

- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    [_collectionView release], _collectionView = nil;
    
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
    setProxy(@"", 0);
}

#pragma mark-UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CollectionReusableView* header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderReuseIdentifier forIndexPath:indexPath];

    return header;
}

@end

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
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

const int cstBtnHeight = 100;
const int cstBtnWidth  = 200;

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
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
    UIImagePickerController* pickerCtrl = [[UIImagePickerController alloc] init];
    pickerCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerCtrl.delegate = self;
    
    [self presentViewController:pickerCtrl animated:YES completion:^{
        
    }];
}


#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self fetchDataFromPickingImage:info complete:^(NSData * imageData) {
        NSLog(@"image data length : %zd", [imageData length]);
        
        char* buffer = (char*)malloc(imageData.length);
        [imageData getBytes:buffer length:imageData.length];
        NSLog(@"first char : %c", buffer[0]);
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-
- (void)fetchDataFromPickingImage:(NSDictionary<NSString *,id> *)info complete:(void(^)(NSData* imageData))complete
{
    if (@available(iOS 11.0, *))
    {
        NSURL* imageURL = [info objectForKey:UIImagePickerControllerImageURL];
        NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
        complete(imageData);
    }
    else
    {
        NSURL* assetsURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsWithALAssetURLs:@[assetsURL] options:0];
        
        PHImageRequestOptions* option = [[PHImageRequestOptions alloc] init];
        [[PHImageManager defaultManager] requestImageDataForAsset:result.firstObject options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            complete(imageData);
        }];
        
    }
}
@end

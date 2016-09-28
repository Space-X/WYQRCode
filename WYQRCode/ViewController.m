//
//  ViewController.m
//  WYQRCode
//
//  Created by wangyue on 2016/9/28.
//  Copyright © 2016年 wangyue. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WYQRCodeScanViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)qrcodeButtonClick:(id)sender {
    if ([self judgeCameraAccessStatus]) {
        WYQRCodeScanViewController *qrcodeVC = [[WYQRCodeScanViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:qrcodeVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (BOOL)judgeCameraAccessStatus
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"请开启相机权限" message:@"手机设置->隐私->相机->风信子" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            return ;
        }];
        return NO;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
    }else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"找不到相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

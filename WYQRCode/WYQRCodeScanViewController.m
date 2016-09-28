//
//  WYQRCodeScanViewController.m
//  WYQRCode
//
//  Created by wangyue on 2016/9/28.
//  Copyright © 2016年 wangyue. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "WYQRCodeScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WYQRScanView.h"
#import "WYQRBackView.h"
#import "WYWebViewController.h"

@interface WYQRCodeScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *session;//输入输出的中间桥梁
    WYQRScanView *_scanView;//扫描区域视图
}
@end

@implementation WYQRCodeScanViewController
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"二维码扫描";
    [self scanViewInit];
    [self startScanQRCode];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [session stopRunning];
}
#pragma mark Init
- (void)scanViewInit
{
    //扫描区域
    CGRect scanRect = CGRectMake((SCREEN_WIDTH - 234)/2, (SCREEN_HEIGHT - 234)/2, 234, 234);
    
    //半透明背景
    WYQRBackView *backView = [[WYQRBackView alloc]initWithFrame:self.view.bounds];
    backView.scanFrame = scanRect;
    [self.view addSubview:backView];
    
    //设置扫描区域
    _scanView = [[WYQRScanView alloc]initWithFrame:scanRect];
    [self.view addSubview:_scanView];
    
    //提示文字
    UILabel *label = [UILabel new];
    label.text = @"将二维码放入框内，即开始扫描";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    label.center = CGPointMake(_scanView.center.x,_scanView.frame.origin.y+_scanView.frame.size.height+20);
    [self.view addSubview:label];
    
    //返回键
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame = CGRectMake(12, 26, 40, 40);
    [backbutton setBackgroundImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
}
- (void)startScanQRCode
{
    /**
     *  初始化二维码扫描
     */
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置识别区域
    //按比例0~1设置，X、Y调换位置，width、height调换位置
    output.rectOfInterest = CGRectMake(_scanView.frame.origin.y/SCREEN_HEIGHT, _scanView.frame.origin.x/SCREEN_WIDTH, _scanView.frame.size.height/SCREEN_HEIGHT, _scanView.frame.size.width/SCREEN_WIDTH);
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    
    //设置扫码支持的编码格式(二维码)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    [session startRunning];
}
#pragma mark 二维码扫描的回调
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [session stopRunning];//停止扫描
        [_scanView stopAnimaion];//暂停动画
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        //输出扫描字符串
        //        NSLog(@"%@",[metadataObject.stringValue containsString:@"admin.dr.fengxz.com.cn"]);
        
        if (metadataObject.stringValue.length >0) {
            WYWebViewController *webView = [[WYWebViewController alloc] init];
            webView.url = metadataObject.stringValue;
            [self.navigationController pushViewController:webView animated:YES];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"这个二维码木有找到，试试别的吧~" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
        }
    }
}
#pragma mark action
//点击返回按钮回调
-(void)clickBackButton{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - UIAlertViewDelegate <NSObject>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  WYWebViewController.m
//  WYQRCode
//
//  Created by wangyue on 2016/9/28.
//  Copyright © 2016年 wangyue. All rights reserved.
//

#import "WYWebViewController.h"

@interface WYWebViewController ()<UIWebViewDelegate>
{
    NSTimer *timer;
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation WYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configWebView];
}
- (void)configWebView
{
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    if (self.url.length) {
        NSString *encodedUrl=[_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]];
        [self.webView loadRequest:request];
    }
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.bounces = NO;
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 5);
    self.progressView.progressTintColor = [UIColor redColor];
    [self.view addSubview:self.progressView];
}
#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    self.progressView.progress = 0.01;
    self.progressView.hidden = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIView animateKeyframesWithDuration:0.35 delay:0.0 options:UIViewKeyframeAnimationOptionAutoreverse animations:^{
        self.progressView.progress = 1.0f;
    } completion:^(BOOL finished) {
        [timer invalidate];
        self.progressView.hidden = YES;
    }];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
- (void)updateProgress
{
    self.progressView.progress += 0.05;
    if (self.progressView.progress >= 0.95) {
        self.progressView.progress = 0.95;
    }
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

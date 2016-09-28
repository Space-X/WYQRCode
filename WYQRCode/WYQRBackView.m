//
//  WYQRBackView.m
//  WYQRCode
//
//  Created by wangyue on 2016/9/28.
//  Copyright © 2016年 wangyue. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#import "WYQRBackView.h"

@implementation WYQRBackView

- (void)drawRect:(CGRect)rect {
    _scanFrame = CGRectMake((SCREEN_WIDTH - 234)/2, (SCREEN_HEIGHT - 234)/2, 234, 234);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //填充区域颜色
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.65] set];
    
    //扫码区域上面填充
    CGRect notScanRect = CGRectMake(0, 0, self.frame.size.width, _scanFrame.origin.y);
    CGContextFillRect(context, notScanRect);
    
    //扫码区域左边填充
    rect = CGRectMake(0, _scanFrame.origin.y, _scanFrame.origin.x,_scanFrame.size.height);
    CGContextFillRect(context, rect);
    
    //扫码区域右边填充
    rect = CGRectMake(CGRectGetMaxX(_scanFrame), _scanFrame.origin.y, _scanFrame.origin.x,_scanFrame.size.height);
    CGContextFillRect(context, rect);
    
    //扫码区域下面填充
    rect = CGRectMake(0, CGRectGetMaxY(_scanFrame), self.frame.size.width,self.frame.size.height - CGRectGetMaxY(_scanFrame));
    CGContextFillRect(context, rect);
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


@end

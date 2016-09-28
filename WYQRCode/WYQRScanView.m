//
//  WYQRScanView.m
//  WYQRCode
//
//  Created by wangyue on 2016/9/28.
//  Copyright © 2016年 wangyue. All rights reserved.
//

#import "WYQRScanView.h"
@interface WYQRScanView()

/**
 *  记录当前线条绘制的位置
 */
@property (nonatomic,assign) CGPoint position;

/**
 *  定时器
 */
@property (nonatomic,strong)NSTimer  *timer;

@end


@implementation WYQRScanView

- (void)drawRect:(CGRect)rect {
    CGPoint newPosition = self.position;
    newPosition.y += 1;
    
    //判断y到达底部，从新开始下降
    if (newPosition.y > rect.size.height) {
        newPosition.y = 0;
    }
    
    //重新赋值position
    self.position = newPosition;
    
    // 绘制图片
    UIImage *image = [UIImage imageNamed:@"scan_line"];
    
    [image drawAtPoint:self.position];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *areaView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scan_border"]];
        [areaView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:areaView];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    }
    
    return self;
}

-(void)startAnimaion{
    [self.timer setFireDate:[NSDate date]];
}

-(void)stopAnimaion{
    [self.timer setFireDate:[NSDate distantFuture]];
}

@end

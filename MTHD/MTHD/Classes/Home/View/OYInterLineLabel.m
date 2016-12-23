//
//  OYInterLineLabel.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/22.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYInterLineLabel.h"

@implementation OYInterLineLabel


- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    // 绘制一条从左至右的线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, self.height * 0.5);
    CGContextAddLineToPoint(context, self.width, self.height * 0.5);
    CGContextStrokePath(context);
    
    // 方法二:绘制宽度为1的矩形
//    UIRectFill(CGRectMake(0, self.height * 0.5, self.width, 1));
    
}


@end

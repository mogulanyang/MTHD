//
//  OYNavitionController.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/17.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYNavitionController.h"

@interface OYNavitionController ()

@end

@implementation OYNavitionController

// 该方法仅会走一次，在此处设置navigationBar的背景图
+ (void)initialize {
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    UIImage *image = [UIImage imageNamed:@"bg_navigationBar_normal"];
    UIImage *stretchImage = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
//    UIImage *image = [UIImage imageResizableImageWithImageNamed:@"bg_navigationBar_normal"];
    [navigationBar setBackgroundImage:stretchImage forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupUI {
    
    
    
}

@end

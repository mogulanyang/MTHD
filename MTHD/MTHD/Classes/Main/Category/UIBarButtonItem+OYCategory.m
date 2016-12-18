//
//  UIBarButtonItem+OYCategory.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/17.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "UIBarButtonItem+OYCategory.h"

@implementation UIBarButtonItem (OYCategory)

+ (UIBarButtonItem *)itemWithImage:(NSString *)imageName andTarget:(id)target andAction:(SEL)selector {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",imageName]] forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    //MARK:- 注意设置button的大小
    [button sizeToFit];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
    
    
}

@end

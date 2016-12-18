//
//  UIBarButtonItem+OYCategory.h
//  MTHD
//
//  Created by Orange Yu on 2016/12/17.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (OYCategory)

+ (instancetype)itemWithImage:(NSString *)imageName andTarget:(id)target andAction:(SEL)selector;

@end

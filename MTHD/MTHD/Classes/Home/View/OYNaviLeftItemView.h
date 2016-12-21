//
//  OYNaviLeftItemView.h
//  MTHD
//
//  Created by Orange Yu on 2016/12/18.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OYNaviLeftItemView : UIView

//** 点击button的block回调 */
@property (copy, nonatomic) void(^OYNaviLeftItemViewBlock) ();

/**
 设置icon
 
 @param imageName icon
 @param hlImageName 高亮icon
 */
- (void)setButtonIcon:(NSString *)imageName andHilightedImage:(NSString *)hlImageName;

/**
 设置主标题

 @param text 主标题内容
 */
- (void)setMainLabelText:(NSString *)text;

/**
 设置副标题

 @param text 副标题内容
 */
- (void)setSubLabelText:(NSString *)text;



@end

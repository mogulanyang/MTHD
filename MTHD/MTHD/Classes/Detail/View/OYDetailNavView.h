//
//  OYDetailNavView.h
//  MTHD
//
//  Created by Orange Yu on 2016/12/23.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OYDetailNavView : UIView

/** 点击返回button的回调block */
@property (copy, nonatomic) void(^OYDetailNavViewBlock) ();


@end

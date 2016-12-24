//
//  OYSearchGrouponController.h
//  MTHD
//
//  Created by Orange Yu on 2016/12/24.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYBaseGrouponController.h"

@interface OYSearchGrouponController : OYBaseGrouponController

/** 点击返回按钮的回调 */
@property (copy, nonatomic) void(^OYSearchGrouponControllerBlock)();
/** 选中的城市 */
@property (copy, nonatomic) NSString *selectedCity;

@end

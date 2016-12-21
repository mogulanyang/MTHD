//
//  OYSearchResultModel.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/20.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYSearchResultModel.h"
#import "OYDistrictModel.h"

@implementation OYSearchResultModel

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
// @"HMDistrictModel" --> Class Name
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"districts" : [OYDistrictModel class]};
}

@end

//
//  OYDistrictModel.h
//  MTHD
//
//  Created by Orange Yu on 2016/12/20.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OYDistrictModel : NSObject

//** 左边显示的地区分类 */
@property (strong, nonatomic) NSString *name;

//** 右边显示的地区名 */
@property (strong, nonatomic) NSArray *subdistricts;



@end

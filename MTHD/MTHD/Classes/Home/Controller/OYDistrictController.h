//
//  OYDistrictController.h
//  MTHD
//
//  Created by Orange Yu on 2016/12/19.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYDistrictModel.h"

@interface OYDistrictController : UIViewController

//** 地区模型数组 */
@property (strong, nonatomic) NSArray<OYDistrictModel *> *districtModelList;

@end

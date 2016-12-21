//
//  OYPopoverView.h
//  MTHD
//
//  Created by Orange Yu on 2016/12/19.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYCategoryModel.h"
#import "OYDistrictModel.h"

@interface OYPopoverView : UIView

//** 分类模型数组 */
@property (strong, nonatomic) NSArray<OYCategoryModel *> *categorymodelList;

//** 地区模型数组 */
@property (strong, nonatomic) NSArray<OYDistrictModel *> *districtmodelList;


@end

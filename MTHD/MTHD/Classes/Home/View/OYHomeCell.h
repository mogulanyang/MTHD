//
//  OYHomeCell.h
//  MTHD
//
//  Created by Orange Yu on 2016/12/21.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OYHomeStatusModel;
@interface OYHomeCell : UICollectionViewCell

/** 首页团购数据模型 */
@property (strong, nonatomic) OYHomeStatusModel *dealsModel;


@end

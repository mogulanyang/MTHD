//
//  OYCitiesModel.h
//  MTHD
//
//  Created by Orange Yu on 2016/12/19.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OYCitiesModel : NSObject


//** 城市分类 */
@property (copy, nonatomic) NSString *title;
//** 城市名数组 */
@property (strong, nonatomic) NSArray *cities;


@end

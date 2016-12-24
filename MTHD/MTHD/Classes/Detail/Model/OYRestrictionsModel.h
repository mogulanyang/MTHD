//
//  OYRestrictionsModel.h
//  MTHD
//
//  Created by Orange Yu on 2016/12/23.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OYRestrictionsModel : NSObject

/** 是否需要预约 */
@property (nonatomic) int is_reservation_required;
/** 是否支持随时退款 0:支持 */
@property (nonatomic) int is_refundable;

@end

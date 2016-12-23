//
//  OYHomeStatusModel.h
//  MTHD
//
//  Created by Orange Yu on 2016/12/22.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OYHomeStatusModel : NSObject

/** 团购单ID */
@property (copy, nonatomic) NSString *deal_id;

/** 团购标题 */
@property (copy, nonatomic) NSString *title;

//不能使用description
/** 团购描述 */
@property (copy, nonatomic) NSString *desc;

//要想保持服务器的价格, NSString  NSNumber
/** 团购包含商品原价值 */
@property (nonatomic, assign) CGFloat list_price;
/** 处理后的原价字符串 */
@property (nonatomic, copy) NSString *listPriceStr;

/** 团购价格 */
@property (nonatomic, assign) CGFloat current_price;
/** 处理后的现价字符串 */
@property (nonatomic, copy) NSString *currentPriceStr;


/** 团购当前已购买数 */
@property (assign, nonatomic) int purchase_count;

/** 团购图片链接，最大图片尺寸450×280 */
@property (copy, nonatomic) NSString *image_url;

/** 小尺寸团购图片链接，最大图片尺寸160×100 */
@property (copy, nonatomic) NSString *s_image_url;

/** 团购发布上线日期*/
@property (copy, nonatomic) NSString *publish_date;
/** 当前团购是否是新单 */
@property (nonatomic) BOOL isLatestGroupon;

/** 团购HTML5页面链接，适用于移动应用和联网车载应用*/
@property (copy, nonatomic) NSString *deal_h5_url;

/** 团购单的截止购买日期*/
@property (copy, nonatomic) NSString *purchase_deadline;

@end

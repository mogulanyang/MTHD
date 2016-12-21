//
//  OYCategoryModel.h
//  MTHD
//
//  Created by Orange Yu on 2016/12/19.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OYCategoryModel : NSObject

/** 名称*/
@property (nonatomic, copy) NSString *name;
/** 图标*/
@property (nonatomic, copy) NSString *icon;
/** 高亮图标*/
@property (nonatomic, copy) NSString *highlighted_icon;
/** 小图标*/
@property (nonatomic, copy) NSString *small_icon;
/** 高亮小图标*/
@property (nonatomic, copy) NSString *small_highlighted_icon;
/** 地图图标*/
@property (nonatomic, copy) NSString *map_icon;
/** 子分类数据*/
@property (nonatomic, strong) NSArray *subcategories;


@end

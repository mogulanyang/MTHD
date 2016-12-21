//
//  OYSearchResultModel.h
//  MTHD
//
//  Created by Orange Yu on 2016/12/20.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OYSearchResultModel : NSObject

/** 名字*/
@property (nonatomic, copy) NSString *name;

/** 拼音全称*/
@property (nonatomic, copy) NSString *pinYin;

/** 拼音缩写*/
@property (nonatomic, copy) NSString *pinYinHead;

/** 子数据(区县街道)--> districts 对应的也是数据模型*/
@property (nonatomic, strong) NSArray *districts;

@end

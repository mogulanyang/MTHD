//
//  OYSortModel.h
//  MTHD
//
//  Created by Orange Yu on 2016/12/20.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OYSortModel : NSObject

/** 排序方式的名称*/
@property(nonatomic,copy)NSString *label;
/** 排序方式的编号*/
@property(nonatomic,assign)NSNumber *value;


@end

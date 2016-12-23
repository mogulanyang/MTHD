//
//  OYHomeStatusModel.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/22.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYHomeStatusModel.h"

@implementation OYHomeStatusModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description"};
}

// 处理现价,小数点后是0的话省略
- (NSString *)dealPrice:(CGFloat)price {
    NSString *priceStr = [NSString stringWithFormat:@"￥%.2f",price];
    if ([priceStr containsString:@".00"]) {
        priceStr = [priceStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }
    return priceStr;
}

- (void)setCurrent_price:(CGFloat)current_price {
    _current_price = current_price;
    self.currentPriceStr = [self dealPrice:current_price];
}

- (void)setList_price:(CGFloat)list_price {
    _list_price = list_price;
    self.listPriceStr = [self dealPrice:list_price];
}

-(void)setPublish_date:(NSString *)publish_date {
    _publish_date = publish_date;
    _isLatestGroupon = [self isLatestGroupon];
}

//MARK:- 判断是否是新单
- (BOOL)isLatestGroupon {
    // 比较与当前日期与publish_date，如果是升序，则为新单
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *publishDate = [dateFormatter dateFromString:self.publish_date];
    NSDate *currentDate = [NSDate date];
    return ([currentDate compare:publishDate] == NSOrderedAscending);
}


@end


//
//  OYDetailSalesReturnView.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/23.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYDetailSalesReturnView.h"

@interface OYDetailSalesReturnView ()

/** 随时退款button */
@property (weak, nonatomic) UIButton *returnAnytimeButton;
/** 团购结束时间button */
@property (weak, nonatomic) UIButton *endTimeButton;
/** 过期退款button */
@property (weak, nonatomic) UIButton *returnOvertimeButton;
/** 已售button */
@property (weak, nonatomic) UIButton *salesCountButton;

@end

@implementation OYDetailSalesReturnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

//MARK:- 为控件加载数据
- (void)setSelectedDealsModel:(OYHomeStatusModel *)selectedDealsModel {
    _selectedDealsModel = selectedDealsModel;
    self.returnAnytimeButton.selected = selectedDealsModel.restrictions.is_refundable == 0;
    self.returnOvertimeButton.selected = selectedDealsModel.restrictions.is_reservation_required == 0;
    [self.salesCountButton setTitle:[NSString stringWithFormat:@"已售 %d",selectedDealsModel.purchase_count] forState:UIControlStateNormal];
    [self handlegrouponDeadlineTime];
}


//MARK:- 处理团购剩余时间
- (void)handlegrouponDeadlineTime {
    // 获取当前时间
    NSDate *currentDate = [NSDate date];
    // 获取团购结束时间
    NSString *deadLineStr = self.selectedDealsModel.purchase_deadline;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *deadLineDate = [dateFormatter dateFromString:deadLineStr];
    // 对两个时间进行比较，如果结束时间大于一年，则显示一年内有效，如果小于等于0，表示团购已经过期
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [calendar components:unit fromDate:currentDate toDate:deadLineDate options:0];
    if (components.day > 365) {
        [self.endTimeButton setTitle:@"一年内有效" forState:UIControlStateNormal];
    }else if (components.day + components.hour + components.minute <= 0) {
        [self.endTimeButton setTitle:@"已过期" forState:UIControlStateNormal];
    }else {
        [self.endTimeButton setTitle:[NSString stringWithFormat:@"%zd天%zd小时%zd分钟",components.day,components.hour,components.minute] forState:UIControlStateNormal];
    }
}

//MARK:- 添加子控件并设置约束
- (void)setupUI {
    [self createButtons];

    [self.returnAnytimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.width.equalTo(self).dividedBy(2);
        make.height.equalTo(self).dividedBy(2);
    }];
    [self.endTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.returnAnytimeButton.mas_right);
        make.height.width.equalTo(self).dividedBy(2);
    }];
    [self.returnOvertimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.returnAnytimeButton.mas_bottom);
        make.left.equalTo(self.returnAnytimeButton);
        make.height.width.equalTo(self).dividedBy(2);
    }];
    [self.salesCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.returnOvertimeButton.mas_right);
        make.top.equalTo(self.returnOvertimeButton);
        make.height.width.equalTo(self).dividedBy(2);
    }];
    
}

//MARK:- 添加四个button
- (void)createButtons {
    self.returnAnytimeButton = [self buttonWithTitle:@"支持随时退款"];
    self.endTimeButton = [self buttonWithTitle:@"7天4小时50分钟"];
    self.returnOvertimeButton = [self buttonWithTitle:@"支持过期退款"];
    self.salesCountButton = [self buttonWithTitle:@"已售373787"];
}

//MARK:- 创建button的方法
- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:@"icon_order_unrefundable"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_order_refundable"] forState:UIControlStateSelected];
    
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
   
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    
    [self addSubview:button];
    return button;
}

@end

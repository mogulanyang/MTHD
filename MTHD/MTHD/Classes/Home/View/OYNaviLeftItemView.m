//
//  OYNaviLeftItemView.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/18.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYNaviLeftItemView.h"

@interface OYNaviLeftItemView()

//** 主标题标签 */
@property (strong, nonatomic) UILabel *mainLabel;
//** 副标题标签 */
@property (strong, nonatomic) UILabel *subLabel;
//** 分隔竖线 */
@property (strong, nonatomic) UILabel *seperatorLineLabel;
//** 功能button */
@property (strong, nonatomic) UIButton *functionButton;

@end

@implementation OYNaviLeftItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.size = CGSizeMake(140, 40);
    
    [self addSubview:self.mainLabel];
    [self addSubview:self.subLabel];
    [self addSubview:self.seperatorLineLabel];
    [self addSubview:self.functionButton];
    
    
}

//MARK:- 控件懒加载
- (UILabel *)mainLabel {
    if (!_mainLabel) {
        _mainLabel = [[UILabel alloc]init];
        _mainLabel.frame = CGRectMake(0, 0,self.width,20);
        _mainLabel.textAlignment = NSTextAlignmentCenter;
        _mainLabel.text = @"主标题";
        _mainLabel.font = [UIFont systemFontOfSize:14];
    }
    return _mainLabel;
}

- (UILabel *)subLabel {
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.frame = CGRectMake(0, 20, self.width, 20);
        _subLabel.textAlignment = NSTextAlignmentCenter;
        _subLabel.text = @"副标题";
        _subLabel.font = [UIFont systemFontOfSize:17];
        
    }
    return _subLabel;
}

- (UILabel *)seperatorLineLabel {
    if (!_seperatorLineLabel) {
        _seperatorLineLabel = [[UILabel alloc]init];
        _seperatorLineLabel.frame = CGRectMake(5, 5, 1, 30);
        _seperatorLineLabel.backgroundColor = OYColor(222, 222, 222);
    }
    return _seperatorLineLabel;
}

- (UIButton *)functionButton {
    if (!_functionButton) {
        _functionButton = [[UIButton alloc]init];
        _functionButton.frame = CGRectMake(0, 0, self.width, self.height);
        [_functionButton setImage:[UIImage imageNamed:@"icon_district"] forState:UIControlStateNormal];
        [_functionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_functionButton setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        
        [_functionButton addTarget:self action:@selector(funcBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _functionButton;
}

//MARK:- button响应事件（执行block回调）
- (void)funcBtnAction {
    self.OYNaviLeftItemViewBlock();
}

@end

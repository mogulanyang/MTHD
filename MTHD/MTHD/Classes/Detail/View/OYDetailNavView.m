//
//  OYDetailNavView.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/23.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYDetailNavView.h"

@interface OYDetailNavView ()

/** 背景条 */
@property (strong, nonatomic) UIImageView *backgroundView;
/** 返回button */
@property (strong, nonatomic) UIButton *backButton;
/** 标题 */
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation OYDetailNavView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.backButton];
    [self addSubview:self.titleLabel];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self).offset(10);
    }];
    
}

//MARK:- 控件懒加载
- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc]init];
        _backgroundView.image = [UIImage imageNamed:@"bg_navigationBar_normal"];
    }
    return _backgroundView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc]init];
        [_backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"icon_back_highlighted"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.text = @"团购详情";
    }
    return _titleLabel;
}
//MARK:- backButton 点击事件
- (void)backButtonAction {
    self.OYDetailNavViewBlock();
}
@end

//
//  OYDetailMainView.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/23.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYDetailMainView.h"
#import "OYInterLineLabel.h"
#import "OYDetailSalesReturnView.h"
#import <UIImageView+WebCache.h>

@interface OYDetailMainView ()

/** 团购图片 */
@property (strong, nonatomic) UIImageView *grouponImageView;
/** 团购标题 */
@property (strong, nonatomic) UILabel *groupomNameLabel;
/** 团购描述 */
@property (strong, nonatomic) UILabel *descriptionLabel;
/** 团购价格 */
@property (strong, nonatomic) UILabel *currentPriceLabel;
/** 原价 */
@property (strong, nonatomic) OYInterLineLabel *originalPriceLabel;
/** 立即抢购button */
@property (strong, nonatomic) UIButton *shopButton;
/** 收藏button */
@property (strong, nonatomic) UIButton *collectButton;
/** 分享button */
@property (strong, nonatomic) UIButton *shareButton;
/** 退货view */
@property (strong, nonatomic) OYDetailSalesReturnView *salesReturnView;


@end

@implementation OYDetailMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

//MARK:- 为子控件加载数据
- (void)setHomeStatusModel:(OYHomeStatusModel *)homeStatusModel {
    _homeStatusModel = homeStatusModel;
    [self.grouponImageView sd_setImageWithURL:[NSURL URLWithString:homeStatusModel.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    self.groupomNameLabel.text = homeStatusModel.title;
    self.descriptionLabel.text = homeStatusModel.desc;
    self.currentPriceLabel.text = homeStatusModel.currentPriceStr;
    self.originalPriceLabel.text = homeStatusModel.listPriceStr;
    
    self.salesReturnView.selectedDealsModel = homeStatusModel;
}

//MARK:- 子控件布局和约束
- (void)setupUI {
    [self addSubview:self.grouponImageView];
    [self addSubview:self.groupomNameLabel];
    [self addSubview:self.descriptionLabel];
    [self addSubview:self.currentPriceLabel];
    [self addSubview:self.originalPriceLabel];
    [self addSubview:self.shopButton];
    [self addSubview:self.collectButton];
    [self addSubview:self.shareButton];
    [self addSubview:self.salesReturnView];
    
    [self.grouponImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
        make.height.mas_equalTo(200);
    }];
    [self.groupomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.grouponImageView);
        make.top.equalTo(self.grouponImageView.mas_bottom).offset(8);
    }];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.grouponImageView);
        make.top.equalTo(self.groupomNameLabel.mas_bottom).offset(15);
    }];
    [self.currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(15);
        make.left.equalTo(self.descriptionLabel);
    }];
    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentPriceLabel.mas_right).offset(8);
        make.baseline.equalTo(self.currentPriceLabel);
    }];
    [self.shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentPriceLabel);
        make.top.equalTo(self.currentPriceLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shopButton);
        make.centerX.equalTo(self).offset(15);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.collectButton);
        make.right.equalTo(self).offset(-8);
    }];
    [self.salesReturnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.shopButton.mas_bottom).mas_equalTo(30);
        make.height.mas_equalTo(80);
    }];
    
}

//MARK:- 控件懒加载
- (UIImageView *)grouponImageView {
    if (!_grouponImageView) {
        _grouponImageView = [[UIImageView alloc]init];
    }
    return _grouponImageView;
}

- (UILabel *)groupomNameLabel {
    if (!_groupomNameLabel) {
        _groupomNameLabel = [[UILabel alloc]init];
    }
    return _groupomNameLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc]init];
        _descriptionLabel.font = [UIFont systemFontOfSize:14];
        _descriptionLabel.textColor = [UIColor darkGrayColor];
        _descriptionLabel.numberOfLines = 0;
    }
    return _descriptionLabel;
}

- (UILabel *)currentPriceLabel {
    if (!_currentPriceLabel) {
        _currentPriceLabel = [[UILabel alloc]init];
        _currentPriceLabel.font = [UIFont systemFontOfSize:17];
        _currentPriceLabel.textColor = [UIColor redColor];
    }
    return _currentPriceLabel;
}

- (OYInterLineLabel *)originalPriceLabel {
    if (!_originalPriceLabel) {
        _originalPriceLabel = [[OYInterLineLabel alloc]init];
        _originalPriceLabel.font = [UIFont systemFontOfSize:14];
    }
    return _originalPriceLabel;
}

- (UIButton *)shopButton {
    if (!_shopButton) {
        _shopButton = [[UIButton alloc]init];
        [_shopButton setBackgroundImage:[UIImage imageNamed:@"bg_deal_purchaseButton"] forState:UIControlStateNormal];
        [_shopButton setBackgroundImage:[UIImage imageNamed:@"bg_deal_purchaseButton_highlighted"] forState:UIControlStateHighlighted];
        [_shopButton sizeToFit];
        [_shopButton setTitle:@"立即抢购" forState:UIControlStateNormal];
    }
    return _shopButton;
}

- (UIButton *)collectButton {
    if (!_collectButton) {
        _collectButton = [[UIButton alloc]init];
        [_collectButton setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"icon_collect_highlighted"] forState:UIControlStateSelected];
    }
    return _collectButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc]init];
        [_shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"icon_share_highlighted"] forState:UIControlStateHighlighted];
    }
    return _shareButton;
}

- (OYDetailSalesReturnView *)salesReturnView {
    if (!_salesReturnView) {
        _salesReturnView = [[OYDetailSalesReturnView alloc]init];
    }
    return _salesReturnView;
}
@end

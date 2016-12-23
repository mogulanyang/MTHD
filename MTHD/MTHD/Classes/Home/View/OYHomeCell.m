//
//  OYHomeCell.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/21.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYHomeCell.h"
#import "OYHomeStatusModel.h"
#import <UIImageView+WebCache.h>
#import "OYInterLineLabel.h"

@interface OYHomeCell ()

/** 背景图 */
@property (strong, nonatomic) UIImageView *backGroundView;
/** 商品图 */
@property (strong, nonatomic) UIImageView *iconView;
/** 团购名 */
@property (strong, nonatomic) UILabel *grouponNameLabel;
/** 团购详情 */
@property (strong, nonatomic) UILabel *descriptionLabel;
/** 团购价 */
@property (strong, nonatomic) UILabel *currentPriceLabel;
/** 原价 */
@property (strong, nonatomic) OYInterLineLabel *originalPriceLabel;
/** 销量 */
@property (strong, nonatomic) UILabel *saleCountsLabel;
/** 新团购标签 */
@property (strong, nonatomic) UIImageView *latestGrouponView;


@end

@implementation OYHomeCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

//MARK:- 为子控件加载数据
-(void)setDealsModel:(OYHomeStatusModel *)dealsModel {
    _dealsModel = dealsModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:dealsModel.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    self.grouponNameLabel.text = dealsModel.title;
    self.descriptionLabel.text = dealsModel.desc;
    self.currentPriceLabel.text = dealsModel.currentPriceStr;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥ %g",dealsModel.list_price]];
//    [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(1) range:NSMakeRange(0, attributedString.length)];
//    self.originalPriceLabel.attributedText = attributedString;
    self.originalPriceLabel.text = [NSString stringWithFormat:@"￥ %g",dealsModel.list_price];
    self.saleCountsLabel.text = [NSString stringWithFormat:@"已售 %d 份",dealsModel.purchase_count];
    self.latestGrouponView.hidden = !dealsModel.isLatestGroupon;
}

//MARK:- 创建子控件并进行布局
- (void)setupUI {
    // 添加
    [self.contentView addSubview:self.backGroundView];
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.grouponNameLabel];
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.currentPriceLabel];
    [self.contentView addSubview:self.originalPriceLabel];
    [self.contentView addSubview:self.saleCountsLabel];
    [self.contentView addSubview:self.latestGrouponView];
    
    // 约束
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(5);
        make.right.offset(-5);
        make.height.offset(180);
    }];
    [self.grouponNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.iconView);
        make.top.equalTo(self.iconView.mas_bottom).offset(10);
    }];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.grouponNameLabel);
        make.top.equalTo(self.grouponNameLabel.mas_bottom).offset(10);
    }];
    [self.currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descriptionLabel);
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(10);
    }];
    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(self.currentPriceLabel);
        make.left.equalTo(self.currentPriceLabel.mas_right).offset(5);
    }];
    [self.saleCountsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(self.originalPriceLabel);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    [self.latestGrouponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
    }];
    
}

//MARK:- 控件的懒加载
- (UIImageView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[UIImageView alloc]init];
        _backGroundView.image = [UIImage imageNamed:@"bg_dealcell"];
    }
    return _backGroundView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.image = [UIImage imageNamed:@"placeholder_deal"];
    }
    return _iconView;
}

- (UILabel *)grouponNameLabel {
    if (!_grouponNameLabel) {
        _grouponNameLabel = [[UILabel alloc]init];
    }
    return _grouponNameLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc]init];
        _descriptionLabel.font = [UIFont systemFontOfSize:14];
        _descriptionLabel.textColor = [UIColor darkGrayColor];
        _descriptionLabel.numberOfLines = 2;
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

- (UILabel *)originalPriceLabel {
    if (!_originalPriceLabel) {
        _originalPriceLabel = [[OYInterLineLabel alloc]init];
        _originalPriceLabel.font = [UIFont systemFontOfSize:14];
        _originalPriceLabel.textColor = [UIColor darkGrayColor];
    }
    return _originalPriceLabel;
}

- (UILabel *)saleCountsLabel {
    if (!_saleCountsLabel) {
        _saleCountsLabel = [[UILabel alloc]init];
        _saleCountsLabel.font = [UIFont systemFontOfSize:14];
        _saleCountsLabel.textColor = [UIColor darkGrayColor];
    }
    return _saleCountsLabel;
}

- (UIImageView *)latestGrouponView {
    if (!_latestGrouponView) {
        _latestGrouponView = [[UIImageView alloc]init];
        _latestGrouponView.image = [UIImage imageNamed:@"ic_deal_new"];
    }
    return _latestGrouponView;
}
@end

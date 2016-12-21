//
//  OYPopoverView.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/19.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYPopoverView.h"

static NSString *OYPopoverControllerCellId = @"OYPopoverControllerCellId";
@interface OYPopoverView ()<UITableViewDataSource,UITableViewDelegate>

/** 左侧tableView*/
@property (strong, nonatomic) UITableView *leftTableView;
//** 右侧tableView */
@property (strong, nonatomic) UITableView *rightTableView;
//** 选中的categorymodel */
@property (strong, nonatomic) OYCategoryModel *selectedCategoryModel;
//** 选中的districtmodel */
@property (strong, nonatomic) OYDistrictModel *selectedDistrictModel;


@end

@implementation OYPopoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        
    }
    return self;
}

//MARK:- 添加子控件并进行布局
- (void)setupUI {
    [self addSubview:self.leftTableView];
    [self addSubview:self.rightTableView];
    
    [self.leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:OYPopoverControllerCellId];
    [self.rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:OYPopoverControllerCellId ];
    
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.equalTo(self).dividedBy(2);
    }];
    
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.width.equalTo(self.leftTableView);
    }];
}

//MARK:- 控件懒加载
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]init];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]init];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _rightTableView;
}

//MARK:- tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.leftTableView) {
        // 左侧cell
        if (self.categorymodelList) {
            return self.categorymodelList.count;
        }else {
            return self.districtmodelList.count;
        }
    }else {
        // 右侧cell
        if (self.categorymodelList) {
            return _selectedCategoryModel.subcategories.count;
        }else {
            return _selectedDistrictModel.subdistricts.count;
        }
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OYPopoverControllerCellId forIndexPath:indexPath];
    if (tableView == self.leftTableView) {
        // 左侧Cell
        if (self.categorymodelList) {
            // 分类数据
            OYCategoryModel *categoryModel = self.categorymodelList[indexPath.row];
            // 设置标题和图片
            cell.textLabel.text = categoryModel.name;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.imageView.image = [UIImage imageNamed:categoryModel.icon];
            cell.imageView.highlightedImage = [UIImage imageNamed:categoryModel.highlighted_icon];
            // 设置
            if (categoryModel.subcategories.count > 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else {
                // 防止复用
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            // 设置cell的背景图片
            UIImage *leftBackgroudView = [UIImage imageNamed:@"bg_dropdown_leftpart"];
            UIImage *leftBackgroundViewSel = [UIImage imageNamed:@"bg_dropdown_left_selected"];
            
            cell.backgroundView = [[UIImageView alloc]initWithImage:leftBackgroudView];
            cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:leftBackgroundViewSel];
        }else {
            // 地区数据
            // 分类数据
            OYDistrictModel *districtModel = self.districtmodelList[indexPath.row];
            // 设置标题和图片
            cell.textLabel.text = districtModel.name;
            cell.textLabel.backgroundColor = [UIColor clearColor];
//            cell.imageView.image = [UIImage imageNamed:districtModel.icon];
//            cell.imageView.highlightedImage = [UIImage imageNamed:districtModel.highlighted_icon];
            // 设置
            if (districtModel.subdistricts.count > 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else {
                // 防止复用
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            // 设置cell的背景图片
            UIImage *leftBackgroudView = [UIImage imageNamed:@"bg_dropdown_leftpart"];
            UIImage *leftBackgroundViewSel = [UIImage imageNamed:@"bg_dropdown_left_selected"];
            
            cell.backgroundView = [[UIImageView alloc]initWithImage:leftBackgroudView];
            cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:leftBackgroundViewSel];
        }
    }else {
        // 设置背景view
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
        // 设置选中的view
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];
        //MARK:- 取消textLabel背景色使得整个cell都是backgroundView
        cell.textLabel.backgroundColor = [UIColor clearColor];
        if (self.categorymodelList) {
            cell.textLabel.text = _selectedCategoryModel.subcategories[indexPath.row];
        }else {
            cell.textLabel.text = _selectedDistrictModel.subdistricts[indexPath.row];
        }
        
    }
    
    return cell;
}

//MARK:- tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 将选中的左侧的cell对应的模型赋值给selectedCategoryModel属性
    //MARK:- 发送通知传递地区名称到HomeVc
    if (tableView == self.leftTableView) {
        // 左边tableview
        if (self.categorymodelList) {
            _selectedCategoryModel = self.categorymodelList[indexPath.row];
            if (self.categorymodelList[indexPath.row].subcategories.count == 0) {
                // 如果左侧cell没有对应右侧分类，则发送通知
                [[NSNotificationCenter defaultCenter]postNotificationName:OYCategorySelectedNotification object:nil userInfo:@{OYSelectedCategoryName:_selectedCategoryModel}];
            }
        }else {
            _selectedDistrictModel = self.districtmodelList[indexPath.row];
            if (self.districtmodelList[indexPath.row].subdistricts.count == 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:OYDistrictSelectedNotification object:nil userInfo:@{OYSelectedDistrictName:_selectedDistrictModel}];
            }
        }
        [self.rightTableView reloadData];
    }else {
        // 右侧tableview
        if (self.categorymodelList) {
            [[NSNotificationCenter defaultCenter]postNotificationName:OYCategorySelectedNotification object:nil userInfo:@{OYSelectedCategoryName:_selectedCategoryModel,OYSelectedDetailCategoryName:_selectedCategoryModel.subcategories[indexPath.row]}];
        }else {
            [[NSNotificationCenter defaultCenter]postNotificationName:OYDistrictSelectedNotification object:nil userInfo:@{OYSelectedDistrictName:_selectedDistrictModel,OYSelectedDetailDistrictName:_selectedDistrictModel.subdistricts[indexPath.row]}];
        }
    }
}
@end

//
//  OYDistrictController.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/19.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYDistrictController.h"
#import "OYCitiesController.h"
#import "OYNavitionController.h"
#import "OYPopoverView.h"

static NSString *OYDistrictControllerCellIdentifier = @"OYDistrictControllerCellIdentifier";
@interface OYDistrictController ()<UITableViewDelegate,UITableViewDataSource>
//** 顶部地区选择的tableView */
@property (strong, nonatomic) UITableView *selectDistrictTableView;

//** popOverView */
@property (strong, nonatomic) OYPopoverView *popoverView;

@end

@implementation OYDistrictController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(350, 395);
    [self setupUI];
}



//MARK:- 设置子控件布局及约束
- (void)setupUI {

    [self.view addSubview:self.selectDistrictTableView];
    [self.view addSubview:self.popoverView];
    
    [self.selectDistrictTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [self.popoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.selectDistrictTableView.mas_bottom);
    }];
    
    self.popoverView.districtmodelList = self.districtModelList;
}

//MARK:- 控件懒加载
- (UITableView *)selectDistrictTableView {
    if (!_selectDistrictTableView) {
        _selectDistrictTableView = [[UITableView alloc]init];
        _selectDistrictTableView.dataSource = self;
        _selectDistrictTableView.delegate = self;
        _selectDistrictTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_selectDistrictTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:OYDistrictControllerCellIdentifier];
    }
    return _selectDistrictTableView;
}

- (OYPopoverView *)popoverView {
    if (!_popoverView) {
        _popoverView = [[OYPopoverView alloc]init];
    }
    return _popoverView;
}

//MARK:- tableViewDataSource & tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OYDistrictControllerCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"切换城市";
    cell.imageView.image = [UIImage imageNamed:@"btn_changeCity"];
    cell.imageView.highlightedImage = [UIImage imageNamed:@"btn_changeCity_selected"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //MARK:- 跳转到城市选择控制器
    [self dismissViewControllerAnimated:YES completion:nil];

    OYCitiesController *citiesVc = [[OYCitiesController alloc]init];
    OYNavitionController *naviVc = [[OYNavitionController alloc]initWithRootViewController:citiesVc];
    // 设置转场样式和呈现样式
    naviVc.modalPresentationStyle = UIModalPresentationFormSheet;
    naviVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:naviVc animated:YES completion:nil];
}
@end

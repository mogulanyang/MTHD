//
//  OYCitiesController.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/19.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYCitiesController.h"
#import "UIBarButtonItem+OYCategory.h"
#import "OYCitiesModel.h"
#import "OYSearchResultController.h"

static NSString *OYCitiesControllerCellIdentifier = @"OYCitiesControllerCellIdentifier";
@interface OYCitiesController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

//** searchBar */
@property (strong, nonatomic) UISearchBar *searchBar;
//** 城市列表 */
@property (strong, nonatomic) UITableView *citiesTableView;
//** 遮罩蒙层button */
@property (strong, nonatomic) UIButton *maskButton;
//** 模型数组 */
@property (strong, nonatomic) NSArray<OYCitiesModel *> *citiesModelList;
//** 搜索结果控制器 */
@property (strong, nonatomic) OYSearchResultController *searchResultVc;


@end

@implementation OYCitiesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self setupUI];
}

//MARK:- 加载数据
- (void)loadData {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"cityGroups.plist" ofType:nil];
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:filePath];
    
    self.citiesModelList = [NSArray yy_modelArrayWithClass:[OYCitiesModel class] json:plistArr];
    
}

//MARK:- 添加布局子控件
- (void)setupUI {
    [self setupNavi];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.citiesTableView];
    [self.view addSubview:self.maskButton];
    [self.maskButton setHidden:YES];
    [self.view addSubview:self.searchResultVc.view];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(15);
        make.right.offset(-15);
    }];
    
    [self.citiesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(15);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.maskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(15);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.searchResultVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(15);
        make.left.right.bottom.equalTo(self.view);
    }];
}
//MARK:- 导航栏设置
- (void)setupNavi {
    self.navigationItem.title = @"选择城市";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_navigation_close" andTarget:self andAction:@selector(dismissCitiesVc)];
}
//MARK:- barbutton点击事件
- (void)dismissCitiesVc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//MARK:- 控件懒加载
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.placeholder = @"请输入城市名或拼音";
        [_searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"]];
        _searchBar.tintColor = OYColor(21, 188, 173);
        _searchBar.delegate = self;
        
    }
    return _searchBar;
}

- (UITableView *)citiesTableView {
    if (!_citiesTableView) {
        _citiesTableView = [[UITableView alloc]init];
        [_citiesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:OYCitiesControllerCellIdentifier];
        _citiesTableView.dataSource = self;
        _citiesTableView.delegate = self;
        _citiesTableView.sectionIndexColor = OYColor(21, 188, 173);
    }
    return _citiesTableView;
}

- (UIButton *)maskButton {
    if (!_maskButton) {
        _maskButton = [[UIButton alloc]init];
        _maskButton.backgroundColor = [UIColor blackColor];
        _maskButton.alpha = 0.3;
        [_maskButton addTarget:self action:@selector(maskButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskButton;
}

- (OYSearchResultController *)searchResultVc {
    if (!_searchResultVc) {
        _searchResultVc = [[OYSearchResultController alloc]init];
        [self addChildViewController:_searchResultVc];
        [_searchResultVc.view setHidden:true];
    }
    return _searchResultVc;
}

//MARK:- maskButton响应事件
- (void)maskButtonAction {
    [self.searchBar resignFirstResponder];
}

//MARK:- UISearchBarDelegate
/// 搜索栏开始输入的状态
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"]];
    self.searchBar.showsCancelButton = YES;
    // 遍历子控件，将cancelButton的文字换为中文
    for (UIView *view in searchBar.subviews[0].subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton *)view;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    [self.maskButton setHidden:NO];
}
/// 取消button被点击的时候
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // 取消第一响应者
//    [searchBar resignFirstResponder];
    [searchBar endEditing:YES];
    self.searchBar.showsCancelButton = NO;
    [self.maskButton setHidden:YES];
}

/// 搜索结束输入的状态
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

/// 当搜索栏内输入文字的时候
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // 如果有文字，则显示搜索Vc
    if (searchText.length > 0) {
        [self.searchResultVc.view setHidden:false];
        self.searchResultVc.searchText = searchText;
    }else {
        [self.searchResultVc.view setHidden:true];
    }
}

//MARK:- UItableViewDatasource & UItableviewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.citiesModelList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.citiesModelList[section].cities.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OYCitiesControllerCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.citiesModelList[indexPath.section].cities[indexPath.row];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.citiesModelList[section].title;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //MARK:- 设置索引
    NSMutableArray<NSString *> *indexArr = [NSMutableArray array ];
    for (OYCitiesModel *citiesModel in self.citiesModelList) {
        [indexArr addObject:citiesModel.title];
    }
    return indexArr.copy;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //MARK:- 选中了cell之后，想HomeVc发送通知
    NSString *selectedCityName = self.citiesModelList[indexPath.section].cities[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:OYCityDidChangeNotifacation object:nil userInfo:@{OYSelectCityName:selectedCityName}];
}

@end

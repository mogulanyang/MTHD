//
//  OYHomeController.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/17.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYHomeController.h"
#import "UIBarButtonItem+OYCategory.h"
#import "OYNaviLeftItemView.h"
#import "OYPopoverController.h"
#import "OYDistrictController.h"
#import "OYSearchResultModel.h"
#import "OYSortController.h"
#import "OYCategoryModel.h"
#import "OYHomeCell.h"
#import "DPAPI.h"
#import "OYHomeStatusModel.h"
#import "OYSortModel.h"
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import "AwesomeMenu.h"

@interface OYHomeController ()<DPRequestDelegate>

/** 当前选择的城市 */
@property (copy, nonatomic) NSString *selectedCity;
/** 当前选择的地区 */
@property (copy, nonatomic) NSString *selectedRegion;
/** 当前选择的分类 */
@property (copy, nonatomic) NSString *selectedCategoty;
/** 当前选择的排序类型 */
@property (strong, nonatomic) NSNumber *selectedSorting;

/** categoryView */
@property (weak, nonatomic) OYNaviLeftItemView *categoryView;
/** districtView */
@property (weak, nonatomic) OYNaviLeftItemView *districtView;
/** sortView */
@property (weak, nonatomic) OYNaviLeftItemView *sortView;
/** 首页团购数据模型数组 */
@property (strong, nonatomic) NSMutableArray<OYHomeStatusModel *> *dealsList;
/** 没有团购数据的默认图 */
@property (strong, nonatomic) UIImageView *noGrouponView;

/** 当前页数 */
@property (assign, nonatomic) NSInteger currentPage;



@end

@implementation OYHomeController

//MARK:- 初始化的时候设置flowLayout
- (instancetype)init {
    return [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置背景颜色
    self.collectionView.backgroundColor = OYColor(222, 222, 222);
    
    self.selectedCity = @"北京";
    // Register cell classes
    [self.collectionView registerClass:[OYHomeCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //MARK:- 设置默认页码
    self.currentPage = 1;
    
    [self setupRightNavi];
    [self setupLeftNavi];
    [self loadData];
    [self setupUI];
    [self setupRefresh];
}

//MARK:- 设置上拉和下拉刷新
- (void)setupRefresh {
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self loadData];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self loadData];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

//MARK:- 加载网络数据
- (void)loadData {
    DPAPI *dpApi = [[DPAPI alloc]init];
    [SVProgressHUD show];
    NSString *urlStr = @"v1/deal/find_deals";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = self.selectedCity;
    if (self.selectedCategoty) {
        params[@"category"] = self.selectedCategoty;
    }
    if (self.selectedRegion) {
        params[@"region"] = self.selectedRegion;
    }
    if (self.selectedSorting) {
        params[@"sort"] = self.selectedSorting;
    }
    params[@"page"] = @(self.currentPage);
    NSLog(@"请求参数为%@",params);
    [dpApi requestWithURL:urlStr params:params delegate:self];
    
}

//MARK:- 设置导航栏左侧按钮
- (void)setupLeftNavi {
    // 美团logo
    UIBarButtonItem *logoItem = [UIBarButtonItem itemWithImage:@"icon_meituan_logo" andTarget:nil andAction:nil];
    // 通过关闭用户交互关闭高亮效果
    logoItem.customView.userInteractionEnabled = false;
//    self.navigationItem.leftBarButtonItem = logoItem;
    
    // 设置分类
    OYNaviLeftItemView *categoryView = [[OYNaviLeftItemView alloc]init];
    self.categoryView = categoryView;
    [self.categoryView setMainLabelText:@"全部分类"];
    [self.categoryView setSubLabelText:@""];
    [self.categoryView setButtonIcon:@"icon_category_-1" andHilightedImage:@"icon_category_highlighted_-1"];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc]initWithCustomView:categoryView];
    [categoryView setOYNaviLeftItemViewBlock:^{
        [self categoryAction];
        
    }];
    // 地区
    OYNaviLeftItemView *districtView = [[OYNaviLeftItemView alloc]init];
    self.districtView = districtView;
    [self.districtView setMainLabelText:@"北京-全部"];
    [self.districtView setSubLabelText:@""];
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc]initWithCustomView:districtView];
    [districtView setOYNaviLeftItemViewBlock:^{
        [self districtAction];
    }];
    // 排序
    OYNaviLeftItemView *sortView = [[OYNaviLeftItemView alloc]init];
    self.sortView = sortView;
    [self.sortView setMainLabelText:@"排序"];
    [self.sortView setSubLabelText:@"默认排序"];
    [self.sortView setButtonIcon:@"icon_sort" andHilightedImage:@"icon_sort_highlighted"];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc]initWithCustomView:sortView];
    [sortView setOYNaviLeftItemViewBlock:^{
        [self sortAction];
    }];
    // 设置左侧按钮
    self.navigationItem.leftBarButtonItems = @[logoItem,categoryItem,districtItem,sortItem];
}

//MARK:- 设置导航栏右侧按钮
- (void)setupRightNavi {
    UIBarButtonItem *locationButton = [UIBarButtonItem itemWithImage:@"icon_district" andTarget:self andAction:@selector(locationAction)];
    // 通过设置item的宽度来设置间距
    locationButton.customView.width = 60;
    UIBarButtonItem *searchButton = [UIBarButtonItem itemWithImage:@"icon_search" andTarget:self andAction:@selector(searchButton)];
    searchButton.customView.width = 60;
    self.navigationItem.rightBarButtonItems = @[locationButton,searchButton];
}

//MARK:- DPRequestDelegate
// 请求失败
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"请求失败,错误原因---%@",error);
    //MARK:- 数据加载失败停止刷新
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    
    [SVProgressHUD showErrorWithStatus:@"请求失败"];
}
// 请求成功
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    NSLog(@"请求成功");
//    NSLog(@"%@",result);
    NSDictionary *responseDic = result;
    NSArray *dealsArray = responseDic[@"deals"];
    [SVProgressHUD dismiss];
    //MARK:- 通过判断上拉刷新和下拉刷新对数组进行处理
    if (self.currentPage == 1) {
        [self.dealsList removeAllObjects];
    }
    [self.dealsList addObjectsFromArray: [NSArray yy_modelArrayWithClass:[OYHomeStatusModel class] json:dealsArray]];

    //MARK:- 根据数据的有无判断没有团购的图像是否显示
    self.noGrouponView.hidden = !(self.dealsList.count == 0);

    //MARK:- 数据加载成功停止刷新
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    
    [self.collectionView reloadData];
//    NSLog(@"%@",dealsArray);

}
//MARK:- collectionViewDatasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dealsList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OYHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.dealsModel = self.dealsList[indexPath.item];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

//MARK:- 导航栏相关点击事件
- (void)sortAction {
    OYSortController *sortVc = [[OYSortController alloc]init];
    
    sortVc.modalPresentationStyle = UIModalPresentationPopover;
    sortVc.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItems[3];
    
    [self presentViewController:sortVc animated:true completion:nil];
    
}

/**
 点击地区按钮响应事件
 */
- (void)districtAction {
    OYDistrictController *districtVc = [[OYDistrictController alloc]init];
    districtVc.modalPresentationStyle = UIModalPresentationPopover;
    districtVc.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItems[2];
    
    //MARK:- 加载当前选中城市的数据，将模型数组传递给districtVc
    // 1.拿到模型数组
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"cities.plist" ofType:nil];
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:filePath];
    NSArray *districtModelArr = [NSArray yy_modelArrayWithClass:[OYSearchResultModel class] json:plistArr];
    // 2.遍历模型数组，取出与当前选中城市名相符的地区模型数组
    for (OYSearchResultModel *districtModel in districtModelArr) {
        if ([districtModel.name isEqualToString:self.selectedCity]) {
             districtVc.districtModelList = districtModel.districts;
        }
    }

    [self presentViewController:districtVc animated:YES completion:nil];
}


/**
 点击分类按钮响应事件
 */
- (void)categoryAction {
    // Modal出HomePopoverVC
    OYPopoverController *popoverVc = [[OYPopoverController alloc]init];
    // 设置modal样式和modal微博
    popoverVc.modalPresentationStyle = UIModalPresentationPopover;
    popoverVc.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItems[1];

    // 进行modal
    [self presentViewController:popoverVc animated:true completion:nil];
}

- (void)locationAction {
    NSLog(@"点击了定位");
}

- (void)searchButton {
    NSLog(@"点击了搜索");
}
//MARK:- 设置子控件布局
- (void)setupUI {
    [self handleNotification];
    [self setupAwesomeMenu];
    [self viewWillTransitionToSize:[UIScreen mainScreen].bounds.size withTransitionCoordinator:self.transitionCoordinator];
    
    //MARK:- 添加没有团购的图片，默认隐藏
    [self.view addSubview:self.noGrouponView];
    self.noGrouponView.hidden = true;
    [self.noGrouponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.collectionView);
    }];
}

- (void)setupAwesomeMenu{
    // 开始按钮
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"] highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    // 我
    AwesomeMenuItem *mineItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_highlighted"]];
    // 收藏
    AwesomeMenuItem *collectItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    // 预览
    AwesomeMenuItem *scanItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    // 更多
    AwesomeMenuItem *moreItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    NSArray *items = @[mineItem, collectItem, scanItem, moreItem];
    
    // 实例化
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem menuItems:items];
    // 设置point
    menu.startPoint = CGPointMake(0, 0);
    // 禁止转头
    menu.rotateAddButton = false;
    // 设置展现样式
    menu.menuWholeAngle = M_PI_2;
    // 添加
    [self.view addSubview:menu];
    
    //    // 约束
    [menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(50);
        make.bottom.equalTo(self.view).offset(-100);
    }];
}

//MARK:- 设置cell的布局
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    flowLayout.itemSize = CGSizeMake(305, 305);
    
    int col = 0;
    CGFloat margin = 0;
    if (size.width > size.height) {
        // 横屏
        col = 3;
    }else {
        // 竖屏
        col = 2;
    }
    margin = (size.width - col * flowLayout.itemSize.width) / (col + 1);

    flowLayout.minimumLineSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
}

- (void)handleNotification {
    //MARK:- 添加监听者接收通知
    // 监听OYSearchResultController&OYCitiesController发送的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedCityAction:) name:OYCityDidChangeNotifacation object:nil];
    // 监听OYPopoverView发送的分类通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedCategoryAction:) name:OYCategorySelectedNotification object:nil];
    // 监听OYPopoverView发送的地区通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedDistrictAction:) name:OYDistrictSelectedNotification object:nil];
    // 监听OYSortController发送的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedSortingAction:) name:OYSortSelectedNotification object:nil];
    
}

//MARK:- 通知监听事件
/// 监听OYSearchResultController&OYCitiesController发送过来的通知
- (void)selectedCityAction:(NSNotification *)noti {
    NSString *selectedCityName = noti.userInfo[OYSelectCityName];
    //MARK:- 赋值给全局的选中城市的变量
    self.selectedCity = selectedCityName;
    
    [self.districtView setMainLabelText:[NSString stringWithFormat:@"%@-全部",selectedCityName]];
    [self.districtView setSubLabelText:@""];
    
    //MARK:- 当切换城市的时候，将选中地区清空，重新请求数据
    self.selectedRegion = nil;
    [self.collectionView.mj_header beginRefreshing];
    [self dismissViewControllerAnimated:true completion:nil];
    
//    NSLog(@"%@",selectedCityName);
}
/// 监听OYPopoverView发送过来的地区通知
- (void)selectedCategoryAction:(NSNotification *)noti {
    OYCategoryModel *categoryModel = noti.userInfo[OYSelectedCategoryName];
    NSString *detailCategoryName = noti.userInfo[OYSelectedDetailCategoryName];
    
    [self.categoryView setMainLabelText:categoryModel.name];
    [self.categoryView setSubLabelText:detailCategoryName];
    [self.categoryView setButtonIcon:categoryModel.icon andHilightedImage:categoryModel.highlighted_icon];
    
    //MARK:- 为self.selectedCategoty赋值
    if (detailCategoryName == nil || [detailCategoryName isEqualToString:@"全部"]) {
        // 如果选中项没有右侧数据，或者右侧选中了全部，则返回左侧数据
        self.selectedCategoty = categoryModel.name;
    }else {
        // 如果选中了右侧出全部外的数据，返回右侧数据
        self.selectedCategoty = detailCategoryName;
    }
    // 如果选中了左侧全部分类，则将选中的分类设置为nil
    if ([categoryModel.name isEqualToString:@"全部分类"]) {
        self.selectedCategoty = nil;
    }
    //MARK:- 当选中了团购分类之后，重新请求数据
    [self.collectionView.mj_header beginRefreshing];
    [self dismissViewControllerAnimated:true completion:nil];
}
/// 监听OYPopoverView发送过来的地区通知
- (void)selectedDistrictAction:(NSNotification *)noti {
    OYDistrictModel *districtModel = noti.userInfo[OYSelectedDistrictName];
    NSString *detailDistrictName = noti.userInfo[OYSelectedDetailDistrictName];
    
    [self.districtView setMainLabelText:[NSString stringWithFormat:@"%@-%@",self.selectedCity,districtModel.name]];
    [self.districtView setSubLabelText:detailDistrictName];
    
    //MARK:- 为self.selectedRegion赋值
    if (detailDistrictName == nil || [detailDistrictName isEqualToString:@"全部"]) {
        self.selectedRegion = districtModel.name;
    }else {
        self.selectedRegion = detailDistrictName;
    }
    
    if ([districtModel.name isEqualToString:@"全部"]) {
        self.selectedRegion = nil;
    }
    //MARK:- 当选中了地区分类之后，重新请求数据
    [self.collectionView.mj_header beginRefreshing];
    [self dismissViewControllerAnimated:true completion:nil];
}

/// 监听OYSortController发送的通知
- (void)selectedSortingAction:(NSNotification *)noti {
    OYSortModel *sortModel = noti.userInfo[OYSelectedSortingName];
    
    [self.sortView setButtonIcon:@"icon_sort" andHilightedImage:@"icon_sort_highlighted"];
    [self.sortView setMainLabelText:@"排序"];
    [self.sortView setSubLabelText:sortModel.label];
    
    //MARK:- 当选中了排序类型之后，重新请求数据
    self.selectedSorting = sortModel.value;
    [self.collectionView.mj_header beginRefreshing];
    
    [self dismissViewControllerAnimated:true completion:nil];
}

//MARK:- 数据懒加载
- (NSArray<OYHomeStatusModel *> *)dealsList {
    if (!_dealsList) {
        _dealsList = [[NSMutableArray alloc]init];
    }
    return _dealsList;
}

- (UIImageView *)noGrouponView {
    if (!_noGrouponView) {
        _noGrouponView = [[UIImageView alloc]init];
        _noGrouponView.image = [UIImage imageNamed:@"icon_deals_empty"];
    }
    return _noGrouponView;
}
@end

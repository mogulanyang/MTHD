//
//  OYBaseGrouponController.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/24.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYBaseGrouponController.h"
#import <MJRefresh.h>
#import "DPAPI.h"
#import <SVProgressHUD.h>
#import "OYHomeStatusModel.h"
#import "OYHomeCell.h"
#import "OYDetailController.h"


@interface OYBaseGrouponController ()<DPRequestDelegate>

/** 当前页数 */
@property (assign, nonatomic) NSInteger currentPage;
/** 首页团购数据模型数组 */
@property (strong, nonatomic) NSMutableArray<OYHomeStatusModel *> *dealsList;
/** 没有团购数据的默认图 */
@property (strong, nonatomic) UIImageView *noGrouponView;

@end

@implementation OYBaseGrouponController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init {
    return [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //MARK:- 设置默认页码
    self.currentPage = 1;
    
    
    //MARK:- 添加没有团购的图片，默认隐藏
    [self.view addSubview:self.noGrouponView];
    self.collectionView.backgroundColor = OYColor(222, 222, 222);
    self.noGrouponView.hidden = true;
    [self.noGrouponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
        
    [self viewWillTransitionToSize:[UIScreen mainScreen].bounds.size withTransitionCoordinator:self.transitionCoordinator];

    // Register cell classes
    [self.collectionView registerClass:[OYHomeCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self setupRefresh];
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
    
}

//MARK:- 设置请求参数，因为在子类中需要的参数不同，所以在父类空实现即可
- (void)setRequestParams:(NSMutableDictionary *)params {}

//MARK:- 加载网络数据
- (void)loadData {
    DPAPI *dpApi = [[DPAPI alloc]init];
    [SVProgressHUD show];
    NSString *urlStr = @"v1/deal/find_deals";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self setRequestParams:params];

    params[@"page"] = @(self.currentPage);
    NSLog(@"请求参数为%@",params);
    [dpApi requestWithURL:urlStr params:params delegate:self];
    
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

    // 得到团购个数的总数
    NSInteger totalCount = [result[@"total_count"] integerValue];
    
    // 如果团购的总数 ==dataArray.count 也就代表服务器没有了数据了 就不可以上拉加载跟多
    if (totalCount == self.dealsList.count) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OYDetailController *detailVc = [[OYDetailController alloc]init];
    detailVc.selectedDealsModel = self.dealsList[indexPath.item];
    [self presentViewController:detailVc animated:true completion:nil];
    
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

//
//  OYSearchResultController.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/20.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYSearchResultController.h"
#import "OYSearchResultModel.h"

static NSString *OYSearchResultControllerCellIdentifier = @"OYSearchResultControllerCellIdentifier";
@interface OYSearchResultController ()<UITableViewDataSource,UITableViewDelegate>

//** 查询结果的tableview */
@property (strong, nonatomic) UITableView *resultTableView;
//** 存放所有城市的数组 */
@property (strong, nonatomic) NSArray<OYSearchResultModel *> *searchResultModelList;
//** 存放搜索结果的数组 */
@property (strong, nonatomic) NSMutableArray<OYSearchResultModel *> *searchResultArr;


@end

@implementation OYSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self setupUI];
}

//MARK:- 加载数据
- (void)loadData {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"cities.plist" ofType:nil];
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:filePath];
    self.searchResultModelList = [NSArray yy_modelArrayWithClass:[OYSearchResultModel class] json:plistArr];
}

//MARK:- 子控件布局和约束
- (void)setupUI {
    [self.view addSubview:self.resultTableView];
    
    [self.resultTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

//MARK:- 监听输入的搜索信息
-(void)setSearchText:(NSString *)searchText {
    _searchText = searchText;
    
    // 将输入全部转成小写
    searchText = searchText.lowercaseString;
    // 输入新文字的时候将之前的搜索结果数组清空
    [self.searchResultArr removeAllObjects];
    //MARK:- 通过搜索信息将符合条件的城市存放至搜索结果数组中
    for (OYSearchResultModel *searchModel in self.searchResultModelList) {
        if ([searchModel.name containsString:searchText] || [searchModel.pinYinHead containsString:searchText] || [searchModel.pinYin containsString:searchText]) {
            [self.searchResultArr addObject:searchModel];
        }
    }
    [self.resultTableView reloadData];
    NSLog(@"输入了%@",searchText);
}

//MARK:- 控件懒加载
- (UITableView *)resultTableView {
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc]init];
        _resultTableView.dataSource = self;
        _resultTableView.delegate = self;
        [_resultTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:OYSearchResultControllerCellIdentifier];
    }
    return _resultTableView;
}

- (NSMutableArray<OYSearchResultModel *> *)searchResultArr {
    if (!_searchResultArr) {
        _searchResultArr = [[NSMutableArray alloc]init];
    }
    return _searchResultArr;
}
//MARK:- UITableViewDataSource&UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OYSearchResultControllerCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.searchResultArr[indexPath.row].name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //MARK:- 选中cell时，发送通知，传递当前选中的城市名
    NSString *selectedCityName = self.searchResultArr[indexPath.row].name;

    [[NSNotificationCenter defaultCenter]postNotificationName:OYCityDidChangeNotifacation object:nil userInfo:@{OYSelectCityName:selectedCityName}];
    
}
@end

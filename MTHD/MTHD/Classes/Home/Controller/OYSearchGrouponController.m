//
//  OYSearchGrouponController.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/24.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYSearchGrouponController.h"
#import <MJRefresh.h>

@interface OYSearchGrouponController ()<UISearchBarDelegate>

/** 返回button */
@property (strong, nonatomic) UIButton *backButton;
/** searchBar */
@property (strong, nonatomic) UISearchBar *grouponSearchBar;

@end

@implementation OYSearchGrouponController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI {
    
    self.collectionView.backgroundColor = OYColor(222, 222, 222);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];

    [self.collectionView.mj_header endRefreshing];
    
    self.navigationItem.titleView = self.grouponSearchBar;
}

//MARK:- 设置搜索需要的参数
-(void)setRequestParams:(NSMutableDictionary *)params {
    params[@"city"] = self.selectedCity;
    params[@"keyword"] = self.grouponSearchBar.text;
    
}

//MARK:- UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 收回键盘
    [searchBar resignFirstResponder];
    // 开启刷新，发送请求
    [self.collectionView.mj_header beginRefreshing];
    
    
}

//MARK:- 控件懒加载
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc]init];
        [_backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"icon_back_highlighted"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_backButton sizeToFit];   
    }
    return _backButton;
}

- (UISearchBar *)grouponSearchBar {
    if (!_grouponSearchBar) {
        _grouponSearchBar = [[UISearchBar alloc]init];
        _grouponSearchBar.placeholder = @"请输入搜索内容";
        _grouponSearchBar.delegate = self;
    }
    return _grouponSearchBar;
}

- (void)backButtonAction {
    self.OYSearchGrouponControllerBlock();
}

@end

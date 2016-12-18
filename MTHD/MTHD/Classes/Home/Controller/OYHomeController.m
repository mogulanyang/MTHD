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

@interface OYHomeController ()

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
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self setupRightNavi];
    [self setupLeftNavi];
    [self setupUI];
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
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc]initWithCustomView:categoryView];
    [categoryView setOYNaviLeftItemViewBlock:^{
        NSLog(@"点击了分类");
    }];
    // 地区
    OYNaviLeftItemView *districtView = [[OYNaviLeftItemView alloc]init];
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc]initWithCustomView:districtView];
    [districtView setOYNaviLeftItemViewBlock:^{
        NSLog(@"点击了地区");
    }];
    // 排序
    OYNaviLeftItemView *sortView = [[OYNaviLeftItemView alloc]init];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc]initWithCustomView:sortView];
    [sortView setOYNaviLeftItemViewBlock:^{
        NSLog(@"点击了排序");
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

//MARK:- 导航栏相关点击事件
- (void)locationAction {
    NSLog(@"点击了定位");
}

- (void)searchButton {
    NSLog(@"点击了搜索");
}
//MARK:- 设置子控件布局
- (void)setupUI {
    
}

@end

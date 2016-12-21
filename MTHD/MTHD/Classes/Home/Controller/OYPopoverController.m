//
//  OYPopoverController.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/19.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYPopoverController.h"
#import "OYCategoryModel.h"
#import "OYPopoverView.h"


@interface OYPopoverController ()

//** 分类列表的模型数组 */
@property (strong, nonatomic) NSArray<OYCategoryModel *> *categoryList;

//** popoverView */
@property (strong, nonatomic) OYPopoverView *popoverView;

@end

@implementation OYPopoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置size
    self.preferredContentSize = CGSizeMake(350, 350);
    [self loadData];
    [self setupUI];
}

//MARK:- 添加子控件并进行布局
- (void)setupUI {
    [self.view addSubview:self.popoverView];
    
    [self.popoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

//MARK:- 从plist加载数据
- (void)loadData {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"categories.plist" ofType:nil];
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:filePath];
    self.categoryList = [NSArray yy_modelArrayWithClass:[OYCategoryModel class] json:plistArr];
    self.popoverView.categorymodelList = self.categoryList;
}
//MARK:- 控件懒加载
- (OYPopoverView *)popoverView {
    if (!_popoverView) {
        _popoverView = [[OYPopoverView alloc]init];
    }
    return _popoverView;
}
@end

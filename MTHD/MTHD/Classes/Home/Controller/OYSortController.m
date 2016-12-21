//
//  OYSortController.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/20.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYSortController.h"
#import "OYSortModel.h"

@interface OYSortController ()

//** 存放model的数组 */
@property (strong, nonatomic) NSArray<OYSortModel *> *sortModelList;


@end

@implementation OYSortController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupUI];
}

- (void)loadData {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"sorts.plist" ofType:nil];
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:filePath];
    self.sortModelList = [NSArray yy_modelArrayWithClass:[OYSortModel class] json:plistArr];
    
}

- (void)setupUI {
    
    CGFloat buttonW = 100;
    CGFloat buttonH = 40;
    CGFloat margin = 5;
    // 循环创建7个button
    for (int i = 0; i < 7; i++) {
        // button的布局和相关UI设置
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, buttonH * i + margin, buttonW, buttonH);
        
        [button setTitle:self.sortModelList[i].label forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button.tag = i;
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        
        // 添加button的点击监听事件
        [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    self.preferredContentSize = CGSizeMake(buttonW, buttonH * 7 + margin * 2);
}

//MARK:- button点击事件
- (void)buttonClickAction:(UIButton *)sender {
    
    // 拿到当前点击的button的模型，获取当前点击的button的内容
    NSString *currentLabel = self.sortModelList[sender.tag].label;
    
    // 发送通知，将点击的内容传至homeVc
    [[NSNotificationCenter defaultCenter]postNotificationName:OYSortSelectedNotification object:nil userInfo:@{OYSelectedSortingName:currentLabel}];
    
}

@end

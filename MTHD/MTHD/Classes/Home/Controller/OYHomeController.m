//
//  OYHomeController.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/17.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYHomeController.h"

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
    
    
}



@end

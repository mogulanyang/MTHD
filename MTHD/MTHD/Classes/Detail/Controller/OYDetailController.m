//
//  OYDetailController.m
//  MTHD
//
//  Created by Orange Yu on 2016/12/23.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//

#import "OYDetailController.h"
#import "OYDetailNavView.h"
#import "OYDetailMainView.h"
#import "DPAPI.h"

@interface OYDetailController ()<DPRequestDelegate,UIWebViewDelegate>

/** 自定义导航view */
@property (strong, nonatomic) OYDetailNavView *detailNavView;
/** 左侧团购详情view */
@property (strong, nonatomic) OYDetailMainView *detailMainView;
/** 右侧团购详情webView */
@property (strong, nonatomic) UIWebView *detailWebView;



@end

@implementation OYDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = OYColor(240, 240, 240);
    
    [self loadData];
    [self setupUI];
}

//MARK:- 加载数据
- (void)loadData {
    DPAPI *dpApi = [[DPAPI alloc]init];
    NSString *urlStr = @"v1/deal/get_single_deal";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deal_id"] = self.selectedDealsModel.deal_id;
    
    [dpApi requestWithURL:urlStr params:params delegate:self];
    
}

//MARK:- DPRequestDelegate
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"请求失败");
    NSLog(@"%@",error);
}
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    self.selectedDealsModel = [OYHomeStatusModel yy_modelWithJSON:[result[@"deals"] firstObject]];
    self.detailMainView.homeStatusModel = self.selectedDealsModel;

}

//MARK:- UIWebViewDelegate
//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    // 用于获取详情页面的请求特征
//    NSString *requestStr = request.URL.absoluteString;
//    NSLog(@"%@",requestStr);
//    return true;
//}

/// webView完成发送请求之后执行JS代码将不需要的页面元素删除
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSMutableString *jsString = [NSMutableString string];
    [jsString appendString:@"var header = document.getElementsByTagName('header')[0];header.parentElement.removeChild(header);"];
    [jsString appendString:@"var costbox = document.getElementsByClassName('cost-box')[0];costbox.parentElement.removeChild(costbox);"];
    [jsString appendString:@"var buynow = document.getElementsByClassName('buy-now')[0];buynow.parentElement.removeChild(buynow);"];
    [jsString appendString:@"var footer = document.getElementsByClassName('footer')[0];footer.parentElement.removeChild(footer);"];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
//    // js 注入语句
//    NSMutableString *js = [[NSMutableString alloc] init];
//    //- 删除头部- 图文详情描述
//    [js appendString:@"var header=document.getElementsByTagName('header')[0];header.parentElement.removeChild(header);"];
//    // - 价格
//    [js appendString:@"var box=document.getElementsByClassName('cost-box')[0];box.parentElement.removeChild(box);"];
//    // - 立即购买
//    [js appendString:@"var buy=document.getElementsByClassName('buy-now')[0];buy.parentElement.removeChild(buy);"];
//    // - 底部视图
//    [js appendString:@"var footer=document.getElementsByClassName('footer')[0];footer.parentElement.removeChild(footer);"];
//    [webView stringByEvaluatingJavaScriptFromString:js];
}
//MARK:- 添加控件设置约束
- (void)setupUI {

    [self.view addSubview:self.detailNavView];
    [self.view addSubview:self.detailMainView];
    [self.view addSubview:self.detailWebView];
    
    [self.detailNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(400, 64));
    }];
    [self.detailMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailNavView.mas_bottom);
        make.left.right.equalTo(self.detailNavView);
        make.bottom.equalTo(self.view);
    }];
    [self.detailWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailMainView.mas_right).offset(8);
        make.top.right.bottom.equalTo(self.view);
    }];
    
    
    // 设置navView中后退按钮的回调
//    WeakSelf(OYDetailController);
    __weak typeof(OYDetailController *) weakSelf = self;
    [self.detailNavView setOYDetailNavViewBlock:^{
        [weakSelf dismissViewControllerAnimated:true completion:nil];
    }];
}

//MARK:- 控件懒加载
- (OYDetailNavView *)detailNavView {
    if (!_detailNavView) {
        _detailNavView = [[OYDetailNavView alloc]init];
        _detailNavView.backgroundColor = [UIColor whiteColor];
    }
    return _detailNavView;
}

- (OYDetailMainView *)detailMainView {
    if (!_detailMainView) {
        _detailMainView = [[OYDetailMainView alloc]init];
        _detailMainView.backgroundColor = [UIColor whiteColor];
    }
    return _detailMainView;
}

- (UIWebView *)detailWebView {
    // http://m.dianping.com/tuan/deal/moreinfo/21782058
    // 2-21782058
    if (!_detailWebView) {
        _detailWebView = [[UIWebView alloc]init];
        _detailWebView.delegate = self;
        _detailWebView.backgroundColor = OYColor(240, 240, 240);
        _detailWebView.scrollView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        //MARK:- 对dealId进行处理，拼接成图文详情页面的请求，发送请求
        NSString *dealId = self.selectedDealsModel.deal_id;
        NSRange range = [dealId rangeOfString:@"-"];
        NSString *detailRequestId = [dealId substringFromIndex:range.location + range.length];
        [_detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@",detailRequestId]]]];
    }
    return _detailWebView;
}
@end

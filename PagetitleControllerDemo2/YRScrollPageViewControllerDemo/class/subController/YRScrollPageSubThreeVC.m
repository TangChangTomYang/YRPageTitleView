//
//  YRScrollPageSubThreeVC.m
//  YRScrollPageViewControllerDemo
//
//  Created by yangrui on 2017/11/26.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import "YRScrollPageSubThreeVC.h"

@interface YRScrollPageSubThreeVC ()<UITableViewDataSource,UITableViewDelegate,YRScrollPageTableViewDelegate>
@property (nonatomic, strong) YRScrollPageTableView *tableView;
@end

@implementation YRScrollPageSubThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self cancleScrollViewAutoAdjusTopContentInset];
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 下拉刷新
//        [self downPullUpdateData];
//    }];
}



-(void)cancleScrollViewAutoAdjusTopContentInset{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}




// 下拉刷新
- (void)downPullUpdateData {
    
    
    [self .childScrollDelegate didChangeFreshState:YES];
    // 模拟网络请求，1秒后结束刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView.mj_header endRefreshing];
        [self .childScrollDelegate didChangeFreshState:NO];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"%f",scrollView.contentOffset.y);
    
    if ([self.tableView.scrollPageTableDelegate estimateContentSizeHeight] < self.tableView.height) {

        if (scrollView.contentOffset.y > -kNaviHAndPageMenuH) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -kNaviHAndPageMenuH) ;
        }

    }
    
    CGFloat offsetDeltaY = scrollView.contentOffset.y - self.lastContentOffset.y;
    // 滚动时发出通知
    [self.childScrollDelegate scrollView:scrollView didScrollWithOffsetDeltaY:offsetDeltaY];
    self.lastContentOffset = scrollView.contentOffset;
}

-(CGFloat)estimateContentSizeHeight{
    return 0;
    
}
-(UIScrollView *)scrollView{
    
    return self.tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell_1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行",indexPath.row];
    
    return cell;
}


- (YRScrollPageTableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[YRScrollPageTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH- kBottomMargin) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(kScrollViewBeginTopInset, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kScrollViewBeginTopInset, 0, 0, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollPageTableDelegate = self;
    }
    return _tableView;
}


@end

//
//  YRScrollPageViewController.m
//  YRScrollPageViewControllerDemo
//
//  Created by yangrui on 2017/11/26.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import "YRScrollPageViewController.h"

@interface YRScrollPageViewController ()<SPPageMenuDelegate,
                                        UIScrollViewDelegate,
                                        YRScrollPageSubViewControllerDelegate>


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YRScrollPageHeaderView *headerView;
@property (nonatomic, strong) SPPageMenu *pageMenu;

@property (nonatomic, assign) CGFloat lastPageMenuY;
@property (nonatomic, assign) CGPoint lastPanGesturePoint;

@end

@implementation YRScrollPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarTintColor = [UIColor whiteColor];
    self.navAlpha = 0;
    self.navTitleColor = [UIColor clearColor];
    
    self.lastPageMenuY = kHeaderViewH;
    
    // 添加一个全屏的scrollView
    [self.view addSubview:self.scrollView];
    // 添加头部视图
    [self.view addSubview:self.headerView];
    // 添加悬浮菜单
    [self.view addSubview:self.pageMenu];
    
    [self cancleScrollViewAutoAdjusTopContentInset];
    
    
    // 添加4个子控制器
    [self addChildeScrollPageViewController:[[YRScrollPageSubOneVC alloc] init]];
    [self addChildeScrollPageViewController:[[YRScrollPageSubTwoVC alloc] init]];
    [self addChildeScrollPageViewController:[[YRScrollPageSubThreeVC alloc] init]];
    [self addChildeScrollPageViewController:[[YRScrollPageSubFourVC alloc] init]];
    // 先将第一个子控制的view添加到scrollView上去
    [self.scrollView addSubview:self.childViewControllers[0].view];
    
}

-(void)cancleScrollViewAutoAdjusTopContentInset{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

-(void)addChildeScrollPageViewController:(YRScrollPageSubViewController *)childScrollPageVC{
    
    [self addChildViewController:childScrollPageVC];
    childScrollPageVC.childScrollDelegate = self;
}

#pragma mark- childScrollVC 代理
-(void)didChangeFreshState:(BOOL)beginOrEnd{
    
    // 正在刷新时禁止self.scrollView滑动
    self.scrollView.scrollEnabled = !beginOrEnd;
    
}

 // 子控制器上的scrollView 滚动就会调用这个代理方法
-(void)scrollView:(UIScrollView *)scrollView didScrollWithOffsetDeltaY:(CGFloat)offsetDeltaY{
    
      NSLog(@"---didScrollWithOffsetDeltaY---------------(%f)--------",offsetDeltaY);
        // 取出当前正在滑动的tableView
        UIScrollView *scrollingScrollView = scrollView;
        CGFloat deltaY = offsetDeltaY;
        
        CGFloat offsetChangeY;
        
        // 取出的scrollingScrollView并非是唯一的，当有多个子控制器上的scrollView同时滑动时都会发出通知来到这个方法，所以要过滤
       YRScrollPageSubViewController *scrollingPageSubVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
        
        if (scrollingScrollView == [scrollingPageSubVc scrollView] && scrollingPageSubVc.isFirstViewLoaded == NO) {
            
            // 让悬浮菜单跟随scrollView滑动
            CGFloat pageMenuY = self.pageMenu.y;
            NSLog(@"---==========-------pageMenuY: %f ---%d-------------",pageMenuY,kNaviH);
            
            
            if (pageMenuY >= kNaviH) {
                
                NSLog(@"---往上移-----------------------");
                // 往上移
                if (deltaY > 0 && scrollingScrollView.contentOffset.y + kScrollViewBeginTopInset > 0) {
                    
                    if(((scrollingScrollView.contentOffset.y+kScrollViewBeginTopInset+self.pageMenu.y)>=kHeaderViewH) ||scrollingScrollView.contentOffset.y+kScrollViewBeginTopInset < 0) {
                        // 悬浮菜单的y值等于当前正在滑动且显示在屏幕范围内的的scrollView的contentOffset.y的改变量(这是最难的点)
                        pageMenuY += -deltaY;
                        NSLog(@" pageMenuY: %f", pageMenuY);
                        if ( pageMenuY <= kNaviH) {
                             pageMenuY = kNaviH;
                        }
                    }
                }
                else { // 往下移
                     NSLog(@"---往下移------------往下移-----------");
                    if ((scrollingScrollView.contentOffset.y + kScrollViewBeginTopInset+pageMenuY) < kHeaderViewH) {
                       
                        pageMenuY = -scrollingScrollView.contentOffset.y-kScrollViewBeginTopInset+kHeaderViewH;
                        NSLog(@"=======往下移===============往下移=======");
                            if (pageMenuY >= kHeaderViewH) {
                                pageMenuY = kHeaderViewH;
                            }
                        
                        if (pageMenuY < kNaviH) {
                            pageMenuY = kNaviH;
                        }

                    }
                    
                    
//                       pageMenuY = -scrollingScrollView.contentOffset.y-kScrollViewBeginTopInset+kHeaderViewH;
//
//                        if(self.canPullFresh == NO){
//
//                            if (pageMenuY >= kHeaderViewH) {
//                                pageMenuY = kHeaderViewH;
//                            }
//                        }
//
//                        if (pageMenuY <= kNaviH) {
//                            pageMenuY = kNaviH;
//                        }
                    
                }
            }
            self.pageMenu.y = pageMenuY;
            self.headerView.y = self.pageMenu.y-kHeaderViewH;
            
            // 记录悬浮菜单的y值改变量
            offsetChangeY = self.pageMenu.y - self.lastPageMenuY;
            self.lastPageMenuY = self.pageMenu.y;
            
            // 让其余控制器的scrollView跟随当前正在滑动的scrollView滑动
            [self followScrollingScrollView:scrollingScrollView changeOffsetY:offsetChangeY];
            
            [self changeColorWithOffsetY:-self.pageMenu.y + kHeaderViewH];
        }
        scrollingPageSubVc.isFirstViewLoaded = NO;
}

-(void)followScrollingScrollView:(UIScrollView *)scrollingScrollView changeOffsetY:(CGFloat)changeOffsetY{
    YRScrollPageSubViewController *otherScrollPageSubVc = nil;
    for (int i = 0; i < self.childViewControllers.count; i++) {
        otherScrollPageSubVc = self.childViewControllers[i];
        if ([otherScrollPageSubVc scrollView] == scrollingScrollView) {
            continue;
        }
        else {
            CGPoint contentOffSet = [otherScrollPageSubVc scrollView].contentOffset;
            contentOffSet.y += -changeOffsetY;
            [otherScrollPageSubVc scrollView].contentOffset = contentOffSet;
        }
    }
}

-(void)changeColorWithOffsetY:(CGFloat)offsetY {
    // 滑出20偏移时开始发生渐变,(kHeaderViewH - 20 - 64)决定渐变时间长度
    
    if (offsetY >= 0) {
        CGFloat alpha = (offsetY)/(kHeaderViewH-64);
        // 该属性是设置导航栏背景渐变
        self.navAlpha = alpha;
        self.navTitleColor = [UIColor colorWithWhite:0 alpha:alpha];
        
    } else {
        self.navAlpha = 0;
        
    }
}


#pragma mark - SPPageMenuDelegate
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (!self.childViewControllers.count) { return;}
    // 如果上一次点击的button下标与当前点击的buton下标之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * toIndex, 0) animated:YES];
    }
    
    YRScrollPageSubViewController *targetChildScrollingPageSubVc = self.childViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetChildScrollingPageSubVc isViewLoaded]) return;
    
    // 来到这里必然是第一次加载控制器的view，这个属性是为了防止下面的偏移量的改变导致走scrollViewDidScroll
    targetChildScrollingPageSubVc.isFirstViewLoaded = YES;
    
    targetChildScrollingPageSubVc.view.frame = CGRectMake(kScreenW*toIndex, 0, kScreenW, kScreenH);
    UIScrollView *childScrollView = [targetChildScrollingPageSubVc scrollView];
    CGPoint contentOffset = childScrollView.contentOffset;
    
    contentOffset.y = -self.headerView.frame.origin.y-kScrollViewBeginTopInset;
    if (contentOffset.y + kScrollViewBeginTopInset >= kHeaderViewH) {
        contentOffset.y = kHeaderViewH-kScrollViewBeginTopInset;
    }
    childScrollView.contentOffset = contentOffset;
    [self.scrollView addSubview:targetChildScrollingPageSubVc.view];
}



#pragma mark- 头部视图拖动手势滑动 事件
- (void)panGestureAction:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint currenrPoint = [pan translationInView:pan.view];
        CGFloat distanceY = currenrPoint.y - self.lastPanGesturePoint.y;
        self.lastPanGesturePoint = currenrPoint;
        
        YRScrollPageSubViewController *scrollPageSubVC = self.childViewControllers[self.pageMenu.selectedItemIndex];
        CGPoint offset = [scrollPageSubVC scrollView].contentOffset;
        offset.y += -distanceY;
        if (offset.y <= -kScrollViewBeginTopInset) {
            offset.y = -kScrollViewBeginTopInset;
        }
        [scrollPageSubVC scrollView].contentOffset = offset;
    } else {
        [pan setTranslation:CGPointZero inView:pan.view];
        self.lastPanGesturePoint = CGPointZero;
    }
    
}

- (void)headerViewBtnClick:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"我很愉快地\n接受到了你的点击事件" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"退下吧" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
     YRScrollPageSubViewController *scrollingPageSubVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([scrollingPageSubVc scrollView].contentSize.height < kScreenH && [scrollingPageSubVc isViewLoaded]) {
            [[scrollingPageSubVc scrollView] setContentOffset:CGPointMake(0, -kScrollViewBeginTopInset) animated:YES];
        }
    });
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    YRScrollPageSubViewController *scrollingPageSubVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([scrollingPageSubVc scrollView].contentSize.height < kScreenH && [scrollingPageSubVc isViewLoaded]) {
            [[scrollingPageSubVc scrollView] setContentOffset:CGPointMake(0, -kScrollViewBeginTopInset) animated:YES];
        }
    });
}







#pragma mark- 懒加载
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, kScreenW, kScreenH - kBottomMargin);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreenW*4, 0);
        _scrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    return _scrollView;
}

- (YRScrollPageHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[YRScrollPageHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenW, kHeaderViewH);
        _headerView.backgroundColor = [UIColor greenColor];
        [_headerView.button addTarget:self action:@selector(headerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [_headerView addGestureRecognizer:pan];
    }
    return _headerView;
}

- (SPPageMenu *)pageMenu {
    
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreenW, kPageMenuH) trackerStyle:SPPageMenuTrackerStyleLineLongerThanItem];
        [_pageMenu setItems:@[@"第一页",@"第二页",@"第三页",@"第四页"] selectedItemIndex:0];
        _pageMenu.delegate = self;
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:16];
        _pageMenu.selectedItemTitleColor = [UIColor blackColor];
        _pageMenu.unSelectedItemTitleColor = [UIColor colorWithWhite:0 alpha:0.6];
        _pageMenu.tracker.backgroundColor = [UIColor orangeColor];
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.bridgeScrollView = self.scrollView;
        
    }
    return _pageMenu;
}























@end

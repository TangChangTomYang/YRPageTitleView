//
//  YRPageContentView.m
//  YRTitlePageView
//
//  Created by yangrui on 2018/8/20.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "YRPageContentView.h"


@interface YRPageContentView ()<UICollectionViewDelegate, UICollectionViewDataSource>


@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray<UIViewController *> *childVCs;
@property (weak, nonatomic) UIViewController *parentVC;


@property (assign, nonatomic)BOOL isTapChoose;
@property (assign, nonatomic)CGFloat dragStartOffsetX;
@end



@implementation YRPageContentView


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout =  [[UICollectionViewFlowLayout alloc] init];
       
        UIScrollView;
        
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        // 2.创建UICollectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        _collectionView.scrollsToTop = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"abc"];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}


-(instancetype)initWithFrame:(CGRect)frame  childVCs:(NSArray<UIViewController *> *)childVCs parentVC:(UIViewController *)parentVC{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.childVCs = childVCs;
        self.parentVC = parentVC;
        
        
        [self setupUI];
    }
    return self;
    
}

-(void)setupUI{
    
    for (UIViewController *vc in self.childVCs) {
        [self.parentVC addChildViewController:vc];
    }
    
    [self collectionView];
}


#pragma mark- UICollectionViewDelegate, UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childVCs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"abc" forIndexPath:indexPath];
    
    // 2.给Cell设置内容
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIViewController *childVc = self.childVCs[indexPath.row];
    
    childVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVc.view];
    return cell;
}


#pragma mark-

/**用户用手指将要滑动是调用这个方法*/
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.isTapChoose = NO;
    self.dragStartOffsetX = scrollView.contentOffset.x;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(self.isTapChoose == YES ){
        return;
    }
    
    
    // 获取需要的参数
    CGFloat progress = 0;
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    
    
    //判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollWidth = scrollView.frame.size.width;
    
    if (currentOffsetX > self.dragStartOffsetX) {//往左滑
        // floor 是取出浮点数整数的部分
        // 计算progress
        progress = currentOffsetX / scrollWidth - floor(currentOffsetX / scrollWidth);
        
        // 计算sourceIndex
        sourceIndex = (int)(currentOffsetX / scrollWidth);
        
        // 计算targetIndex
        targetIndex = sourceIndex + 1;
        if (targetIndex >= self.childVCs.count) {
            targetIndex = self.childVCs.count -1;
        }
        
        
        // 如果完全滑过去
        if((currentOffsetX - self.dragStartOffsetX) == scrollWidth){
            progress = 1;
            targetIndex = sourceIndex;
        }
    }
    else{ // 往右滑
        // 1.计算progress
        progress = 1 - (currentOffsetX / scrollWidth - floor(currentOffsetX / scrollWidth));
        
        // 2.计算targetIndex
        targetIndex = (int)(currentOffsetX / scrollWidth);
        
        // 3.计算sourceIndex
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= self.childVCs.count) {
            sourceIndex = self.childVCs.count - 1;
        }
    }
    
    // 3.将progress/sourceIndex/targetIndex传递给titleView
    [self.delegate pageContentView:self didScrollProgerss:progress fromIndex:sourceIndex toIndex:targetIndex];
    
}


-(void)setCurrentPageIndex:(NSInteger)pageIndex{
    
    self.isTapChoose = YES;
    
    
    // 2.滚动正确的位置
    CGFloat offsetX = pageIndex * self.collectionView.frame.size.width;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


@end

//
//  YRScrollPageCollectionview.h
//  YRScrollPageViewControllerDemo
//
//  Created by yangrui on 2017/11/26.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YRScrollPageCollectionview;
@protocol YRScrollPageCollectionviewDelegate <NSObject>
@required
-(CGFloat)estimateContentSizeHeight;
@end
@interface YRScrollPageCollectionview : UICollectionView

@property(nonatomic, strong)id<YRScrollPageTableViewDelegate> scrollPageCollectionDelegate;

@end

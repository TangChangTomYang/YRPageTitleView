//
//  YRScrollPageTableView.h
//  YRScrollPageViewControllerDemo
//
//  Created by yangrui on 2017/11/26.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YRScrollPageTableView;
@protocol YRScrollPageTableViewDelegate <NSObject>
@required
-(CGFloat)estimateContentSizeHeight;
@end

@interface YRScrollPageTableView : UITableView

@property(nonatomic, strong)id<YRScrollPageTableViewDelegate> scrollPageTableDelegate;

@end

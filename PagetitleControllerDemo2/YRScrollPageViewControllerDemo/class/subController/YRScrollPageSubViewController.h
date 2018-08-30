//
//  YRScrollPageSubViewController.h
//  YRScrollPageViewControllerDemo
//
//  Created by yangrui on 2017/11/26.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YRScrollPageSubViewController;

@protocol YRScrollPageSubViewControllerDelegate <NSObject>
@required

-(void)scrollView:(UIScrollView *)scrollView didScrollWithOffsetDeltaY:(CGFloat)offsetDeltaY;

-(void)didChangeFreshState:(BOOL)beginOrEnd;

@end

@interface YRScrollPageSubViewController : UIViewController

-(UIScrollView *)scrollView;

@property(nonatomic, assign)id<YRScrollPageSubViewControllerDelegate> childScrollDelegate;

@property (nonatomic, assign) CGPoint lastContentOffset;

@property (nonatomic, assign) BOOL isFirstViewLoaded;
@end

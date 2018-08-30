//
//  YRPageContentView.h
//  YRTitlePageView
//
//  Created by yangrui on 2018/8/20.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YRPageContentView;
@protocol YRPageContentViewDelegate<NSObject>

-(void)pageContentView:(YRPageContentView *)pageContentView didScrollProgerss:(CGFloat)progress fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
@end


@interface YRPageContentView : UIView

@property (weak , nonatomic) id<YRPageContentViewDelegate> delegate;


-(instancetype)initWithFrame:(CGRect)frame  childVCs:(NSArray<UIViewController *> *)childVCs parentVC:(UIViewController *)parentVC;

-(void)setCurrentPageIndex:(NSInteger)pageIndex;
@end

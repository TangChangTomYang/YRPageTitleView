//
//  YRPageTitleView.h
//  YRTitlePageView
//
//  Created by yangrui on 2018/8/20.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YRPageTitleView;

@protocol YRPageTitleViewDelegate<NSObject>

-(void)pageTitleView:(YRPageTitleView *)pageTitleView didSelectTitleAtIndex:(NSInteger)index;
@end



@interface YRPageTitleView : UIView


@property (weak, nonatomic) id<YRPageTitleViewDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles;
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles selectIndex:(NSInteger)selectIndex;

-(void)setProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;
@end

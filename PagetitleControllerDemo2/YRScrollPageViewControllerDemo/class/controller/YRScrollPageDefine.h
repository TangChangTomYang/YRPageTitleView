//
//  YRScrollPageDefine.h
//  YRScrollPageViewControllerDemo
//
//  Created by yangrui on 2017/11/26.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#ifndef YRScrollPageDefine_h
#define YRScrollPageDefine_h


#endif /* YRScrollPageDefine_h */


#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define isIPhoneX       (kScreenH==812)
#define kNaviH          (isIPhoneX ? 84 : 64)
#define kBottomMargin   (isIPhoneX ? 34 : 0)  // iphoneX底部去除34
#define kHeaderViewH    200
#define kPageMenuH      40
#define kNaviHAndPageMenuH       (kPageMenuH + kNaviH)
#define kScrollViewBeginTopInset (kHeaderViewH + kPageMenuH) //240




#import "UINavigationBar+NavAlpha.h"
#import "UINavigationController+NavAlpha.h"


#import "YRScrollPageViewController.h" // 主控制器
#import "YRScrollPageHeaderView.h"
#import "YRScrollPageTableView.h"
#import "YRScrollPageCollectionview.h"


#import "MJRefresh.h"
#import "SPPageMenu.h"





//测试
#import "YRScrollPageSubViewController.h" //自控制器父类

#import "YRScrollPageSubOneVC.h"
#import "YRScrollPageSubTwoVC.h"
#import "YRScrollPageSubThreeVC.h"
#import "YRScrollPageSubFourVC.h"

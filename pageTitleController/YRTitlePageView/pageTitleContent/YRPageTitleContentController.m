//
//  YRPageTitleContentController
//  YRTitlePageView
//
//  Created by yangrui on 2018/8/20.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "YRPageTitleContentController.h"
#import "YRPageTitleView.h"
#import "YRPageContentView.h"

@interface YRPageTitleContentController ()<YRPageTitleViewDelegate,YRPageContentViewDelegate>
@property (strong, nonatomic) YRPageTitleView *pageTitleView;
@property (strong, nonatomic) YRPageContentView *pageCongentView;

@end

@implementation YRPageTitleContentController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupTitleView];
    
    [self setupTitleContentView];
}

-(void)setupTitleView{
    self.view.backgroundColor = [UIColor purpleColor];
    YRPageTitleView *pageTitleView = [[YRPageTitleView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 44) titles:@[@"张三", @"李四", @"王二", @"麻子"]];
    pageTitleView.delegate = self;
    self.pageTitleView = pageTitleView;
    [self.view addSubview:pageTitleView];
}

-(void)setupTitleContentView{
   UIViewController *one = [[UIViewController alloc] init];
    one.view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    
    UIViewController *two = [[UIViewController alloc] init];
    two.view.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
    
    UIViewController *three = [[UIViewController alloc] init];
    three.view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
    
    UIViewController *four = [[UIViewController alloc] init];
    four.view.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    
    NSArray *childs = @[one,two,three, four];
    
    CGRect frame = CGRectMake(0, 64 + 44, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (64 + 44));
   YRPageContentView *pageCongentView = [[YRPageContentView alloc] initWithFrame:frame childVCs:childs parentVC:self];
    pageCongentView.delegate = self;
    [self.view addSubview:pageCongentView];
    self.pageCongentView = pageCongentView;
}


#pragma mark- YRPageTitleViewDelegate
-(void)pageTitleView:(YRPageTitleView *)pageTitleView didSelectTitleAtIndex:(NSInteger)index{
    [self.pageCongentView setCurrentPageIndex:index];
}

#pragma mark- YRPageContentViewDelegate
-(void)pageContentView:(YRPageContentView *)pageContentView didScrollProgerss:(CGFloat)progress fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    
    [self.pageTitleView setProgress:progress sourceIndex:fromIndex targetIndex:toIndex];
}
@end

//
//  YRPageTitleView.m
//  YRTitlePageView
//
//  Created by yangrui on 2018/8/20.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "YRPageTitleView.h"

#define kScrollLineH   2
#define kNormalColor   @[@85, @85, @85]
#define kSelectColor   @[@255, @128, @0]
#define kColorDelta    @[@(255-85), @(128-85), @(0-85)]

#define color(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface YRPageTitleView()

@property (strong, nonatomic) NSArray<NSString *> *titles;
@property (strong, nonatomic) NSMutableArray<UILabel *> *titleLbs;
@property (strong, nonatomic) UIView *scrollLine;


@property (assign, nonatomic) NSInteger currentIndex;
@end


@implementation YRPageTitleView

-(NSMutableArray<UILabel *> *)titleLbs{
    if (!_titleLbs) {
        _titleLbs = [NSMutableArray array];
    }
    return _titleLbs;
}
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles selectIndex:(NSInteger)selectIndex{
    self = [super initWithFrame:frame];
    if (self) {
        if (titles.count  < 2) {
            NSLog(@"警告!! YRPageTitleView 至少需要2个标题 ");
        }
        self.titles = titles;
        self.currentIndex = selectIndex;
        [self setupUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles{
    
    return  [self initWithFrame:frame titles:titles selectIndex:0];
 
}



-(void)setupUI{
    
    [self setupTitleLbs];
    [self setupScrollLine];
    [self setupBottomLine];
}

-(void)setupBottomLine{
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    bottomLine.backgroundColor = color([kNormalColor[0] integerValue], [kNormalColor[1] integerValue], [kNormalColor[2] integerValue]);
    [self addSubview:bottomLine];
    
}

-(void)setupScrollLine{
    UILabel *firstLb = self.titleLbs.firstObject;
    CGRect frame =CGRectMake(0, CGRectGetMaxY(firstLb.frame), firstLb.frame.size.width, kScrollLineH);
    UIView *scrollLine = [[UIView alloc]initWithFrame:frame];
    scrollLine.backgroundColor =  color([kSelectColor[0] integerValue], [kSelectColor[1] integerValue], [kSelectColor[2] integerValue]);
    [self addSubview:scrollLine];
    self.scrollLine = scrollLine;
}

-(void)setupTitleLbs{
    
    // 0.确定label的一些frame的值
    
    CGFloat lbW = self.frame.size.width / self.titles.count;
    CGFloat lbH = self.frame.size.height - kScrollLineH;
    CGFloat lbY = 0;
    for (int i = 0 ; i < self.titles.count; i ++) {
        
        UILabel *lb = [[UILabel alloc]init];
        lb.tag = i ;
        lb.text = self.titles[i];
        lb.font = [UIFont systemFontOfSize:16];
        lb.userInteractionEnabled = YES;
        lb.textAlignment = NSTextAlignmentCenter;
        
        lb.textColor = i == 0 ? color([kSelectColor[0] integerValue], [kSelectColor[1] integerValue], [kSelectColor[2] integerValue]): color([kNormalColor[0] integerValue], [kNormalColor[1] integerValue], [kNormalColor[2] integerValue]);
        
        CGFloat lbX = i * lbW;
        lb.frame = CGRectMake(lbX, lbY, lbW, lbH);
        [self addSubview:lb];
        [self.titleLbs addObject:lb];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
        
        [lb addGestureRecognizer:tap];
    }
    self.currentIndex = 0;
    
}


-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    
    NSInteger index = tap.view.tag;
    
    if (index == self.currentIndex) {
        return;
    }
    
    NSInteger oldIndex = self.currentIndex;
    UILabel *oldLb = self.titleLbs[oldIndex];
    UILabel *currentLb = self.titleLbs[index];

    
    oldLb.textColor = color([kNormalColor[0] integerValue], [kNormalColor[1] integerValue], [kNormalColor[2] integerValue]);
    currentLb.textColor = color([kSelectColor[0] integerValue], [kSelectColor[1] integerValue], [kSelectColor[2] integerValue]);
    
    CGFloat scrollLineX = index * self.scrollLine.frame.size.width;
    CGRect scrollLineFrame = self.scrollLine.frame;
    scrollLineFrame.origin.x = scrollLineX;

    [UIView animateWithDuration:0.25 animations:^{
        self.scrollLine.frame = scrollLineFrame;
    }];
    
    
    NSLog(@"========点击: %ld",index);
    if([self.delegate respondsToSelector:@selector(pageTitleView:didSelectTitleAtIndex:)]){
        [self.delegate pageTitleView:self didSelectTitleAtIndex:index];
    }
    self.currentIndex = index;
}


-(void)setProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
 
    
    UILabel *sourceLb = self.titleLbs[sourceIndex];
    UILabel *targetLb = self.titleLbs[targetIndex];
    
    CGFloat moveTotalX = targetLb.frame.origin.x - sourceLb.frame.origin.x;
    CGFloat moveX = moveTotalX * progress;
    
    CGFloat scrollLineX = sourceLb.frame.origin.x + moveX;
    CGRect frame = self.scrollLine.frame;
    frame.origin.x = scrollLineX;
    self.scrollLine.frame = frame;
    
    
    sourceLb.textColor = color([kSelectColor[0] integerValue] - [kColorDelta[0] integerValue] * progress,
                               [kSelectColor[1] integerValue] - [kColorDelta[1] integerValue] * progress,
                               [kSelectColor[2] integerValue] - [kColorDelta[2] integerValue] * progress);
    targetLb.textColor = color([kNormalColor[0] integerValue] + [kColorDelta[0] integerValue] * progress,
                               [kNormalColor[1] integerValue] + [kColorDelta[1] integerValue] * progress,
                               [kNormalColor[2] integerValue] + [kColorDelta[2] integerValue] * progress);
    
    
    self.currentIndex = targetIndex;
    
}

@end

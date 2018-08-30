//
//  YRScrollPageHeaderView.m
//  YRScrollPageViewControllerDemo
//
//  Created by yangrui on 2017/11/26.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import "YRScrollPageHeaderView.h"

@implementation YRScrollPageHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, 0, 60, 30);
        self.button.backgroundColor = [UIColor yellowColor];
        [self.button setTitle:@"点我" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:self.button];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.button.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
}

@end

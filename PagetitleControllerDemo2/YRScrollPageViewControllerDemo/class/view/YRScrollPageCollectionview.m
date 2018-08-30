//
//  YRScrollPageCollectionview.m
//  YRScrollPageViewControllerDemo
//
//  Created by yangrui on 2017/11/26.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import "YRScrollPageCollectionview.h"

@implementation YRScrollPageCollectionview

-(void)setContentSize:(CGSize)contentSize{
    if (contentSize.height < self.height) {
        [super setContentSize:CGSizeMake(contentSize.width, self.height)];
    }
    else{
        [super setContentSize:contentSize];
        
        
    }
    
}
@end

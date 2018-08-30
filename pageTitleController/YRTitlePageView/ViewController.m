//
//  ViewController.m
//  YRTitlePageView
//
//  Created by yangrui on 2018/8/20.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "ViewController.h"
#import "YRPageTitleContentController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController pushViewController:[[YRPageTitleContentController alloc]init] animated:YES];
}


@end

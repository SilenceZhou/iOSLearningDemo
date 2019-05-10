//
//  ViewController.m
//  ProxyDemo
//
//  Created by zhouyun on 2019/5/10.
//  Copyright © 2019 zhouyun. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController


/// 参考链接： https://juejin.im/post/5afaaf996fb9a07ac5604a92
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"定时器-如何防止内存泄露";
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[TestViewController new] animated:YES];
}


@end

//
//  TestViewController.m
//  ProxyDemo
//
//  Created by zhouyun on 2019/5/10.
//  Copyright © 2019 zhouyun. All rights reserved.
//

#import "TestViewController.h"
#import "NSTimer+Category.h"
#import "CADisplayLink+category.h"
#import "YYWeakProxy.h"


@interface TestViewController ()
{
    dispatch_source_t _gcdTimer;
}

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CADisplayLink * displayLink;


@end

@implementation TestViewController

- (void)dealloc
{
    [self.displayLink invalidate];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"TestViewController";
    
    [self testCADisplayLink_proxy];
}


#pragma mark -
#pragma mark - 内存泄露 - CADisplayLink
#pragma mark - block

/// CADisplayLink是一个频率能达到屏幕刷新率的定时器类。
/// iPhone屏幕刷新频率为60帧/秒，也就是说最小间隔可以达到1/60s。

- (void)testCADisplayLink_block
{
    /// 使用 block模式需要dealloc里面进行释放
    //__weak typeof(self) weakSelf = self;
    self.displayLink = [CADisplayLink zy_displayLinkWithExecuteBlock:^(CADisplayLink * _Nonnull timer) {
        // __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"testCADisplayLink_block");
    }];
}

- (void)testCADisplayLink_proxy
{
    //CADisplayLink是一个频率能达到屏幕刷新率的定时器类。iPhone屏幕刷新频率为60帧/秒，也就是说最小间隔可以达到1/60s。
    
    YYWeakProxy *proxy = [YYWeakProxy proxyWithTarget:self];
    
    // 这个地方直接用self不用proxy也会内存泄露
    // 使用self就算在dealloc里面释放也会内存泄露
    self.displayLink = [CADisplayLink displayLinkWithTarget:proxy
                                                   selector:@selector(logInfo:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)logInfo:(CADisplayLink *)displayLink
{
    NSLog(@"testTimer_CADisplayLink");
}


#pragma mark -
#pragma mark - 内存泄露 - NSTimer
#pragma mark - GCD
/**
 *   GCD 计时器应用
 *
 *   dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, <#intervalInSeconds#> * NSEC_PER_SEC, <#leewayInSeconds#> * NSEC_PER_SEC);
 *
 *   dispatch Queue : 决定了将来回调的方法在哪个队列里面执行。
 *   dispatch_source_t:  timer  是一个OC对象
 *   DISPATCH_TIME_NOW : 第二个参数，为类型dispatch_time_t定时器开始时间,也可以使用如下的方法，在Now 的时间基础上再延时多长时间执行以下任务。
      dispatch_time(<#dispatch_time_t when#>, <#int64_t delta#>)
 *   intervalInSeconds:  第三个参数:定时器开始后的间隔时间（纳秒 NSEC_PER_SEC）
 *   leewayInSeconds : 第四个参数：间隔精准度，0代标最精准，传入一个大于0的数， 代表多少秒的范围是可以接收的,主要为了提高程序性能，积攒一定的时间，Runloop执行完任务会睡觉，
     这个方法让他多睡一会，积攒时间，任务也就相应多了一点，而后一起执行
 */

- (void)testTimer_GCD
{
    dispatch_queue_t  queue = dispatch_get_global_queue(0, 0);
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_gcdTimer, ^{
        NSLog(@"CGD timer");
    });
    dispatch_resume(_gcdTimer);
}


#pragma mark - NSProxy

- (void)testTimer_Proxy {
    
    //至于具体的原理，让NSTimer定时中的方法由YYWeakProxy转发给VC执行.但是NStimer持有的却不是VC.这样就不会循环引用.
    
    YYWeakProxy *proxy = [YYWeakProxy proxyWithTarget:self];

    // 方式一
//    _timer = [NSTimer timerWithTimeInterval:1.0
//                                     target:proxy
//                                   selector:@selector(tick:)
//                                   userInfo:nil
//                                    repeats:YES];
//
//    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    // 方式二
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:proxy
                                                selector:@selector(tick:)
                                                userInfo:nil
                                                 repeats:YES];
}


- (void)tick:(NSTimer *)timer
{
    NSLog(@"testTimer_Proxy");
}



#pragma mark - Block

- (void)testTimer_useBlock{
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer js_scheduledTimerWithTimeInterval:1.0
                                               executeBlock:^(NSTimer *timer){
                                                   
                                                   __strong typeof(weakSelf) strongSelf = weakSelf;
                                                   [strongSelf timerFired:timer];
                                                   
                                               }repeats:YES];
    
    
    
}

- (void)timerFired:(NSTimer *)timer
{
//    [timer invalidate];

}


@end

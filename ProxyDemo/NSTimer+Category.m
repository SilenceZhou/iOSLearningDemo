//
//  NSTimer+Category.m
//  ProxyDemo
//
//  Created by zhouyun on 2019/5/10.
//  Copyright © 2019 zhouyun. All rights reserved.
//

#import "NSTimer+Category.h"

@implementation NSTimer (Category)

+ (NSTimer *)js_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                 executeBlock:(JSTimerBlcok)block
                                      repeats:(BOOL)repeats
{
    
    NSTimer *timer = [self scheduledTimerWithTimeInterval:timeInterval
                                                   target:self
                                                 selector:@selector(js_executeTimer:)
                                                 userInfo:[block copy]
                                                  repeats:repeats];
    
    return timer;
    
}

+(void)js_executeTimer:(NSTimer *)timer

{
    JSTimerBlcok block = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end

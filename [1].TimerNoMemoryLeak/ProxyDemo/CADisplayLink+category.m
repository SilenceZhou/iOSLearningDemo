//
//  CADisplayLink+category.m
//  ProxyDemo
//
//  Created by zhouyun on 2019/5/10.
//  Copyright © 2019 zhouyun. All rights reserved.
//

#import "CADisplayLink+category.h"
#import <objc/runtime.h>

@implementation CADisplayLink (category)


+ (CADisplayLink *)zy_displayLinkWithExecuteBlock:(ZYCADisplayLinkBlock)block
{
    CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self
                                                       selector:@selector(jzy_executeTimer:)];
    
    [timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    timer.block = [block copy];
    
    return timer;
    
}

+ (void)jzy_executeTimer:(CADisplayLink *)timer
{
    if (timer.block) {
        timer.block(timer);
    }
}



- (ZYCADisplayLinkBlock)block
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBlock:(ZYCADisplayLinkBlock)block
{
    objc_setAssociatedObject(self, @selector(block), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

//
//  NSTimer+Category.h
//  ProxyDemo
//
//  Created by zhouyun on 2019/5/10.
//  Copyright © 2019 zhouyun. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^JSTimerBlcok)(NSTimer *timer);

@interface NSTimer (Category)

+ (NSTimer *)js_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                  executeBlock:(JSTimerBlcok)block
                                       repeats:(BOOL)repeats;
@end

NS_ASSUME_NONNULL_END

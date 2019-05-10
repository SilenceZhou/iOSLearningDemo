//
//  CADisplayLink+category.h
//  ProxyDemo
//
//  Created by zhouyun on 2019/5/10.
//  Copyright © 2019 zhouyun. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZYCADisplayLinkBlock)(CADisplayLink *timer);

@interface CADisplayLink (category)

@property (nonatomic, copy) ZYCADisplayLinkBlock block;

+ (CADisplayLink *)zy_displayLinkWithExecuteBlock:(ZYCADisplayLinkBlock)block;

@end

NS_ASSUME_NONNULL_END

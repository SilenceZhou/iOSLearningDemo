//
//  YYWeakProxy.h
//  ProxyDemo
//
//  Created by zhouyun on 2019/5/10.
//  Copyright © 2019 zhouyun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYWeakProxy : NSProxy
@property (nullable, nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithTarget:(id)target;


@end

NS_ASSUME_NONNULL_END

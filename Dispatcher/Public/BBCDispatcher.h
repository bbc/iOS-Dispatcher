//
//  BBCDispatcher.h
//  Dispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_UNAVAILABLE("Use the Dispatcher struct instead")
@interface BBCDispatcher <__covariant Target> : NSObject

- (instancetype)initWithTargetClass:(Class)targetClass;
- (instancetype)initWithTargetProtocol:(Protocol*)targetProtocol;

- (void)addTarget:(Target)target;
- (void)removeTarget:(Target)target;
- (Target)dispatch;

@end

@interface BBCDispatcher <__covariant Target> (Blocks)

- (instancetype)initWithTargetClass:(Class)targetClass
                        replayBlock:(void(^)(Target target, NSInvocation *invocation))block;
- (instancetype)initWithTargetProtocol:(Protocol*)targetProtocol
                           replayBlock:(void(^)(Target target, NSInvocation *invocation))block;

@end

NS_ASSUME_NONNULL_END

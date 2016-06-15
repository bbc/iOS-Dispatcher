//
//  BBCDispatcherBlockReplayAction.h
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 03/06/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCDispatcherReplayAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBCDispatcherBlockReplayAction <__covariant Target> : BBCDispatcherReplayAction<Target>

+ (instancetype)replayActionWithBlock:(void (^)(Target target, NSInvocation* invocation))block;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReplayBlock:(void (^)(Target target, NSInvocation* invocation))block NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

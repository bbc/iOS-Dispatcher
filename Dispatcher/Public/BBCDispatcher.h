//
//  BBCDispatcher.h
//  Dispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCDispatcherReplayAction.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_UNAVAILABLE("Use the Dispatcher struct instead")
@interface BBCDispatcher <__covariant Target> : NSObject

- (instancetype)initWithTargetClass:(Class)targetClass;
- (instancetype)initWithTargetClass:(Class)targetClass replayAction:(nullable BBCDispatcherReplayAction<Target> *)action;
- (instancetype)initWithTargetProtocol:(Protocol*)targetProtocol;
- (instancetype)initWithTargetProtocol:(Protocol*)targetProtocol replayAction:(nullable BBCDispatcherReplayAction<Target> *)action;

- (void)addTarget:(Target)target;
- (void)removeTarget:(Target)target;
- (Target)dispatch;

@end

NS_ASSUME_NONNULL_END

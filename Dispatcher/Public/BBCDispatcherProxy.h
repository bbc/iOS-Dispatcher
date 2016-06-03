//
//  BBCDispatcherProxy.h
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 06/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BBCDispatcherReplayAction;

@interface BBCDispatcherProxy : NSProxy

@property (nonatomic, strong, null_resettable) BBCDispatcherReplayAction *replayAction;

+ (instancetype)proxyForClass:(Class)aClass;
+ (instancetype)proxyForProtocol:(Protocol *)aProtocol;

- (instancetype)init;
- (instancetype)initWithTargetClass:(Class)aClass;
- (instancetype)initWithTargetProtocol:(Protocol *)aProtocol;

- (void)addTarget:(id)target;
- (void)removeTarget:(id)target;

@end

NS_ASSUME_NONNULL_END

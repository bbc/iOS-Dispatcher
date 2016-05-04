//
//  BBCMessageMultiplexer.h
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBCMethodSignatureProvider;

NS_ASSUME_NONNULL_BEGIN

@interface BBCMessageMultiplexer <__covariant Target> : NSObject

- (instancetype)initWithTargetClass:(Class)targetClass;
- (instancetype)initWithTargetProtocol:(Protocol*)targetProtocol;
- (instancetype)initWithMethodSignatureProvider:(id<BBCMethodSignatureProvider>)methodSignatureProvider NS_DESIGNATED_INITIALIZER;

- (void)addTarget:(Target)target;
- (void)removeTarget:(Target)target;
- (Target)dispatch;

@end

NS_ASSUME_NONNULL_END

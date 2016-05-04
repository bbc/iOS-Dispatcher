//
//  BBCMessageMultiplexer.m
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCClassMethodSignatureProvider.h"
#import "BBCMessageMultiplexer.h"
#import "BBCProtocolMethodSignatureProvider.h"

@interface BBCMessageMultiplexer ()

@property (nonatomic, strong) id<BBCMethodSignatureProvider> _methodSignatureProvider;
@property (nonatomic, strong) NSMutableSet* targets;
@property (nonatomic, strong) NSInvocation* lastInvocation;

@end

#pragma mark -

@implementation BBCMessageMultiplexer

#pragma mark Initialization

- (instancetype)init
{
    return [self initWithTargetClass:[NSObject class]];
}

- (instancetype)initWithTargetClass:(Class)targetClass
{
    return [self initWithMethodSignatureProvider:[[BBCClassMethodSignatureProvider alloc] initWithClass:targetClass]];
}

- (instancetype)initWithTargetProtocol:(Protocol*)targetProtocol
{
    return [self initWithMethodSignatureProvider:[[BBCProtocolMethodSignatureProvider alloc] initWithProtocol:targetProtocol]];
}

- (instancetype)initWithMethodSignatureProvider:(id<BBCMethodSignatureProvider>)methodSignatureProvider
{
    self = [super init];
    if (self) {
        __methodSignatureProvider = methodSignatureProvider;
        _targets = [NSMutableSet set];
    }

    return self;
}

#pragma mark Public

- (void)addTarget:(id)target
{
    [_targets addObject:target];
    [self performInvocation:_lastInvocation target:target];
}

- (void)removeTarget:(id)target
{
    [_targets removeObject:target];
}

- (id)dispatch
{
    return self;
}

#pragma mark Overrides

- (id)forwardingTargetForSelector:(__unused SEL)aSelector
{
    return self;
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [__methodSignatureProvider targetInstanceMethodSignatureForSelector:aSelector];
    }

    return signature;
}

- (void)forwardInvocation:(NSInvocation*)anInvocation
{
    _lastInvocation = anInvocation;

    for (id target in _targets) {
        [self performInvocation:anInvocation target:target];
    }
}

#pragma mark Private

- (void)performInvocation:(NSInvocation*)invocation target:(id)target
{
    if ([target respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:target];
    }
}

@end

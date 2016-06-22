//
//  BBCDispatcherProxy.m
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 06/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCCachingMethodSignatureProvider.h"
#import "BBCClassMethodSignatureProvider.h"
#import "BBCDispatcherProxy.h"
#import "BBCDispatcherReplayLastInvocationAction.h"
#import "BBCDispatcherTargetCollection.h"
#import "BBCProtocolMethodSignatureProvider.h"
#import <objc/runtime.h>

@interface BBCDispatcherProxy ()

@property (nonatomic, strong) id<BBCMethodSignatureProvider> methodSignatureProvider;
@property (nonatomic, strong) Class targetClass;
@property (nonatomic, strong) Protocol* targetProtocol;
@property (nonatomic, strong) BBCDispatcherTargetCollection* targets;

@end

@implementation BBCDispatcherProxy

#pragma mark Initialization

+ (instancetype)proxyForClass:(Class)aClass
{
    return [[self alloc] initWithTargetClass:aClass];
}

+ (instancetype)proxyForProtocol:(Protocol *)aProtocol
{
    return [[self alloc] initWithTargetProtocol:aProtocol];
}

- (instancetype)init
{
    return [self initWithTargetClass:[NSObject class]];
}

- (instancetype)initWithTargetClass:(Class)targetClass
{
    self = [self initWithMethodSignatureProvider:[[BBCClassMethodSignatureProvider alloc] initWithClass:targetClass]];
    _targetClass = targetClass;
    return self;
}

- (instancetype)initWithTargetProtocol:(Protocol*)targetProtocol
{
    self = [self initWithMethodSignatureProvider:[[BBCProtocolMethodSignatureProvider alloc] initWithProtocol:targetProtocol]];
    _targetProtocol = targetProtocol;
    return self;
}

- (instancetype)initWithMethodSignatureProvider:(id<BBCMethodSignatureProvider>)methodSignatureProvider
{
    _methodSignatureProvider = [[BBCCachingMethodSignatureProvider alloc] initWithMethodSignatureProvider:methodSignatureProvider];

    NSArray<NSValue*>* selectors = _methodSignatureProvider.selectors;
    _targets = [[BBCDispatcherTargetCollection alloc] initWithSelectors:selectors];
    
    _replayAction = [BBCDispatcherReplayLastInvocationAction new];

    return self;
}

#pragma mark Public

- (NSArray *)allTargets
{
    return _targets.allTargets;
}

- (void)addTarget:(id)target
{
    [_targets addTarget:target];
    [_replayAction replayWithTarget:target];
}

- (void)removeTarget:(id)target
{
    [_targets removeTarget:target];
}

#pragma mark Overrides

- (void)setReplayAction:(BBCDispatcherReplayAction *)replayAction
{
    _replayAction = replayAction ?: [BBCDispatcherReplayLastInvocationAction new];
}

- (BOOL)isKindOfClass:(Class)aClass
{
    return [_targetClass isKindOfClass:aClass] || [_targetClass isSubclassOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol*)aProtocol
{
    return protocol_conformsToProtocol(_targetProtocol, aProtocol);
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)sel
{
    return [_methodSignatureProvider targetInstanceMethodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation*)invocation
{
    [_replayAction trackInvocation:invocation];

    for (id target in [_targets targetsRespondingToSelector:invocation.selector]) {
        [invocation invokeWithTarget:target];
    }
}

@end

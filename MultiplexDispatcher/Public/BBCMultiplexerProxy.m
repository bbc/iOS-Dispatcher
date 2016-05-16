//
//  BBCMultiplexerProxy.m
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 06/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCCachingMethodSignatureProvider.h"
#import "BBCClassMethodSignatureProvider.h"
#import "BBCMultiplexerProxy.h"
#import "BBCMultiplexerTargetsCollection.h"
#import "BBCProtocolMethodSignatureProvider.h"
#import <objc/runtime.h>

@interface BBCMultiplexerProxy ()

@property (nonatomic, strong) id<BBCMethodSignatureProvider> methodSignatureProvider;
@property (nonatomic, strong) Class targetClass;
@property (nonatomic, strong) Protocol* targetProtocol;
@property (nonatomic, strong) BBCMultiplexerTargetsCollection* targets;
@property (nonatomic, strong) NSInvocation* lastInvocation;

@end

@implementation BBCMultiplexerProxy

#pragma mark Initialization

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

- (instancetype)initWithTargetProtocolName:(NSString*)protocolName
{
    Protocol* protocol = NSProtocolFromString(protocolName);
    if (protocol) {
        return self = [self initWithTargetProtocol:protocol];
    }
    else {
        return nil;
    }
}

- (instancetype)initWithMethodSignatureProvider:(id<BBCMethodSignatureProvider>)methodSignatureProvider
{
    _methodSignatureProvider = [[BBCCachingMethodSignatureProvider alloc] initWithMethodSignatureProvider:methodSignatureProvider];
    _targets = [[BBCMultiplexerTargetsCollection alloc] initWithTargetSelectors:methodSignatureProvider.selectors];

    return self;
}

#pragma mark Public

- (void)addTarget:(id)target
{
    [_targets addTarget:target];

    if (_lastInvocation && [target respondsToSelector:_lastInvocation.selector]) {
        [_lastInvocation invokeWithTarget:target];
    }
}

- (void)removeTarget:(id)target
{
    [_targets removeTarget:target];
}

#pragma mark Overrides

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
    _lastInvocation = invocation;

    for (id target in [_targets targetsRespondingToSelector:invocation.selector]) {
        [invocation invokeWithTarget:target];
    }
}

@end
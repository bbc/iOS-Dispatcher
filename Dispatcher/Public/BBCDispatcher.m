//
//  BBCDispatcher.m
//  Dispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCDispatcher.h"
#import "BBCDispatcherProxy.h"

@interface BBCDispatcher ()

@property (nonatomic, strong) BBCDispatcherProxy* proxy;

@end

#pragma mark -

@implementation BBCDispatcher

#pragma mark Initialization

- (instancetype)init
{
    return [self initWithTargetClass:[NSObject class]];
}

- (instancetype)initWithTargetClass:(Class)targetClass
{
    self = [super init];
    if (self) {
        _proxy = [[BBCDispatcherProxy alloc] initWithTargetClass:targetClass];
    }

    return self;
}

- (instancetype)initWithTargetProtocol:(Protocol*)targetProtocol
{
    self = [super init];
    if (self) {
        _proxy = [[BBCDispatcherProxy alloc] initWithTargetProtocol:targetProtocol];
    }

    return self;
}

#pragma mark Public

- (void)addTarget:(id)target
{
    [_proxy addTarget:target];
}

- (void)removeTarget:(id)target
{
    [_proxy removeTarget:target];
}

- (id)dispatch
{
    return _proxy;
}

@end

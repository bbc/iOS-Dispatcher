//
//  BBCMultiplexer.m
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCMultiplexer.h"
#import "BBCMultiplexerProxy.h"

@interface BBCMultiplexer ()

@property (nonatomic, strong) BBCMultiplexerProxy* proxy;

@end

#pragma mark -

@implementation BBCMultiplexer

#pragma mark Initialization

- (instancetype)init
{
    return [self initWithTargetClass:[NSObject class]];
}

- (instancetype)initWithTargetClass:(Class)targetClass
{
    self = [super init];
    if (self) {
        _proxy = [[BBCMultiplexerProxy alloc] initWithTargetClass:targetClass];
    }

    return self;
}

- (instancetype)initWithTargetProtocol:(Protocol*)targetProtocol
{
    self = [super init];
    if (self) {
        _proxy = [[BBCMultiplexerProxy alloc] initWithTargetProtocol:targetProtocol];
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

//
//  BBCDispatcher.m
//  Dispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCDispatcher.h"
#import "BBCDispatcherProxy.h"
#import "BBCDispatcherReplayLastInvocationAction.h"

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
    return [self initWithTargetClass:targetClass replayAction:nil];
}

- (instancetype)initWithTargetClass:(Class)targetClass replayAction:(BBCDispatcherReplayAction *)action
{
    return [self initWithProxy:[BBCDispatcherProxy proxyForClass:targetClass] replayAction:action];
}

- (instancetype)initWithTargetProtocol:(Protocol*)targetProtocol
{
    return [self initWithTargetProtocol:targetProtocol replayAction:nil];
}

- (instancetype)initWithTargetProtocol:(Protocol*)targetProtocol replayAction:(nullable BBCDispatcherReplayAction*)action
{
    return [self initWithProxy:[BBCDispatcherProxy proxyForProtocol:targetProtocol] replayAction:action];
}

- (instancetype)initWithProxy:(BBCDispatcherProxy *)proxy replayAction:(BBCDispatcherReplayAction *)action
{
    self = [super init];
    if(self) {
        _proxy = proxy;
        _proxy.replayAction = action;
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

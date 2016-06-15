//
//  BBCDispatcherBlockReplayAction.m
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 03/06/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCDispatcherBlockReplayAction.h"

@interface BBCDispatcherBlockReplayAction ()

@property (nonatomic, copy) void (^block)(id target, NSInvocation* invocation);

@end

#pragma mark -

@implementation BBCDispatcherBlockReplayAction

+ (instancetype)replayActionWithBlock:(void (^)(id target, NSInvocation* invocation))block
{
    return [[self alloc] initWithReplayBlock:block];
}

- (instancetype)initWithReplayBlock:(void (^)(id target, NSInvocation* invocation))block
{
    self = [super init];
    if(self) {
        _block = [block copy];
    }
    
    return self;
}

- (void)replayWithTarget:(id)target
{
    _block(target, self.invocation);
}

@end

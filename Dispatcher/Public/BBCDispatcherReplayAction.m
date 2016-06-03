//
//  BBCDispatcherReplayAction.m
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 03/06/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCDispatcherReplayAction.h"

@interface BBCDispatcherReplayAction ()

@property (nonatomic, strong, readwrite, nullable) NSInvocation* invocation;

@end

#pragma mark -

@implementation BBCDispatcherReplayAction

- (void)trackInvocation:(NSInvocation*)invocation
{
    _invocation = invocation;
    [invocation retainArguments];
}

- (void)replayWithTarget:(__unused id)target
{
    // We're a template method, so do nothing.
}

@end

//
//  BBCDispatcherReplayLastInvocationAction.m
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 03/06/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCDispatcherReplayLastInvocationAction.h"

@implementation BBCDispatcherReplayLastInvocationAction

- (void)replayWithTarget:(id)target
{
    if([target respondsToSelector:self.invocation.selector]) {
        [self.invocation invokeWithTarget:target];
    }
}

@end

//
//  BBCDispatcherMutatorTarget.m
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 22/06/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCDispatcherMutatorTarget.h"

@interface BBCNonmutatingDispatcherTarget : BBCDispatcherMutatorTarget
@end

@implementation BBCNonmutatingDispatcherTarget

- (void)mutate:(__unused BBCDispatcher<BBCDispatcherMutatorTarget*>*)dispatcher
{
}

@end

@implementation BBCDispatcherMutatorTarget

- (void)mutate:(BBCDispatcher<BBCDispatcherMutatorTarget*>*)dispatcher
{
    BBCNonmutatingDispatcherTarget* target = [BBCNonmutatingDispatcherTarget new];
    [dispatcher addTarget:target];
}

@end

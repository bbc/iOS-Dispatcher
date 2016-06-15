//
//  BBCSwiftClosureReplayAction.m
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 15/06/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCSwiftClosureReplayAction.h"

@interface BBCSwiftClosureReplayAction ()

@property (nonatomic, copy) void (^replayClosure)(id<NSObject>);

@end

#pragma mark -

@implementation BBCSwiftClosureReplayAction

#pragma mark Initialization

- (instancetype)init
{
    return [self initWithClosure:nil];
}

- (instancetype)initWithClosure:(void (^)(id<NSObject> target))closure
{
    self = [super init];
    if (self) {
        _replayClosure = [closure copy];
    }

    return self;
}

#pragma mark Overrides

- (void)replayWithTarget:(id<NSObject>)target
{
    if (_replayClosure) {
        _replayClosure(target);
    }
}

@end

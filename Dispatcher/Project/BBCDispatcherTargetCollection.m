//
//  BBCDispatcherTargetCollection.m
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 16/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCDispatcherTargetCollection.h"
#import "BBCSelectorMap.h"

#pragma mark -

@interface BBCDispatcherTargetCollection ()

@property (nonatomic, strong) NSArray<NSValue*>* selectors;
@property (nonatomic, strong) BBCSelectorMap<NSMutableArray*>* storage;

@end

#pragma mark -

@implementation BBCDispatcherTargetCollection

#pragma mark Initialization

- (instancetype)initWithSelectors:(NSArray<NSValue*>*)selectors
{
    self = [super init];
    if (self) {
        _selectors = selectors;
        _storage = [BBCSelectorMap map];

        for (NSValue* selector in selectors) {
            [_storage setObject:[NSMutableArray new] forSelector:selector.pointerValue];
        }
    }

    return self;
}

#pragma mark Public

- (void)addTarget:(id)target
{
    for (NSValue* selector in _selectors) {
        if ([target respondsToSelector:selector.pointerValue]) {
            NSMutableArray* targets = [_storage objectForSelector:selector.pointerValue];
            [targets addObject:target];
        }
    }
}

- (void)removeTarget:(id)target
{
    for (NSValue* selector in _selectors) {
        [[_storage objectForSelector:selector.pointerValue] removeObject:target];
    }
}

- (NSArray*)targetsRespondingToSelector:(SEL)aSelector
{
    return [_storage objectForSelector:aSelector];
}

- (NSArray*)allTargets
{
    NSMutableSet* targets = [NSMutableSet set];
    for (NSArray* subStorage in _storage.allObjects) {
        [targets addObjectsFromArray:subStorage];
    }

    return [targets allObjects];
}

@end

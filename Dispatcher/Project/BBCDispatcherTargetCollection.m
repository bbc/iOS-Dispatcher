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

@property (nonatomic, assign) void** selectors;
@property (nonatomic, assign) NSUInteger selectorsBufferSize;
@property (nonatomic, strong) BBCSelectorMap<NSMutableArray*>* storage;

@end

#pragma mark -

@implementation BBCDispatcherTargetCollection

#pragma mark Initialization

- (instancetype)initWithSelectorsBuffer:(void**)buf bufferSize:(NSUInteger)size
{
    self = [super init];
    if (self) {
        _selectors = buf;
        _selectorsBufferSize = size;
        _storage = [BBCSelectorMap map];

        for (NSUInteger index = 0; index < size; index++) {
            [_storage setObject:[NSMutableArray new] forSelector:buf[index]];
        }
    }

    return self;
}

#pragma mark Public

- (void)addTarget:(id)target
{
    for (NSUInteger index = 0; index < _selectorsBufferSize; index++) {
        SEL selector = _selectors[index];

        if ([target respondsToSelector:selector]) {
            [[_storage objectForSelector:selector] addObject:target];
        }
    }
}

- (void)removeTarget:(id)target
{
    for (NSUInteger index = 0; index < _selectorsBufferSize; index++) {
        SEL selector = _selectors[index];
        [[_storage objectForSelector:selector] removeObject:target];
    }
}

- (NSArray*)targetsRespondingToSelector:(SEL)aSelector
{
    return [_storage objectForSelector:aSelector];
}

@end

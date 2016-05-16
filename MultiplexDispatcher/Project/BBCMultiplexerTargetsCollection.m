//
//  BBCMultiplexerTargetsCollection.m
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 16/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCMultiplexerTargetsCollection.h"

@interface BBCMultiplexerTargetsCollection ()

@property (nonatomic, strong) NSMutableSet* storage;
@property (nonatomic, strong) NSArray* selectors;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableArray*>* selectorToTargetsRespondingToSelector;

@end

#pragma mark -

@implementation BBCMultiplexerTargetsCollection

#pragma mark Initialization

- (instancetype)init
{
    return [self initWithTargetSelectors:@[]];
}

- (instancetype)initWithTargetSelectors:(NSArray<NSString*>*)selectors
{
    self = [super init];
    if (self) {
        _storage = [NSMutableSet set];
        _selectors = [selectors copy];
        _selectorToTargetsRespondingToSelector = [NSMutableDictionary dictionary];

        for (NSString* selector in selectors) {
            _selectorToTargetsRespondingToSelector[selector] = [NSMutableArray array];
        }
    }

    return self;
}

#pragma mark Public

- (void)addTarget:(id)target
{
    [_storage addObject:target];
    [self retainRespondingSelectorsForTarget:target];
}

- (void)removeTarget:(id)target
{
    [_storage removeObject:target];

    for (NSString* selector in _selectorToTargetsRespondingToSelector) {
        [_selectorToTargetsRespondingToSelector[selector] removeObject:target];
    }
}

- (NSArray*)targetsRespondingToSelector:(SEL)aSelector
{
    return _selectorToTargetsRespondingToSelector[NSStringFromSelector(aSelector)];
}

- (void)retainRespondingSelectorsForTarget:(id)target
{
    for (NSString* selector in _selectors) {
        SEL theSelector = NSSelectorFromString(selector);
        if ([target respondsToSelector:theSelector]) {
            [_selectorToTargetsRespondingToSelector[selector] addObject:target];
        }
    }
}

@end

//
//  BBCCachingMethodSignatureProvider.m
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 16/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCCachingMethodSignatureProvider.h"

@interface BBCCachingMethodSignatureProvider ()

@property (nonatomic, strong) id<BBCMethodSignatureProvider> provider;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMethodSignature*>* cachedSignatures;

@end

@implementation BBCCachingMethodSignatureProvider

- (instancetype)initWithMethodSignatureProvider:(id<BBCMethodSignatureProvider>)provider
{
    self = [super init];
    if (self) {
        _provider = provider;
    }

    return self;
}

- (NSArray<NSValue*>*)selectors
{
    return _provider.selectors;
}

- (NSMethodSignature*)targetInstanceMethodSignatureForSelector:(SEL)aSelector
{
    NSString* key = NSStringFromSelector(aSelector);
    NSMethodSignature* signature = _cachedSignatures[key];
    if (!signature) {
        signature = [_provider targetInstanceMethodSignatureForSelector:aSelector];
        _cachedSignatures[key] = signature;
    }

    return signature;
}

@end

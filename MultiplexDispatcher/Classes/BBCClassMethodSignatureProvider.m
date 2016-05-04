//
//  BBCClassMethodSignatureProvider.m
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCClassMethodSignatureProvider.h"

@interface BBCClassMethodSignatureProvider ()

@property (nonatomic, strong) Class targetClass;

@end

#pragma mark -

@implementation BBCClassMethodSignatureProvider

- (instancetype)init
{
    return [self initWithClass:[NSObject class]];
}

- (instancetype)initWithClass:(Class)aClass
{
    self = [super init];
    if (self) {
        _targetClass = aClass;
    }

    return self;
}

- (NSMethodSignature*)targetInstanceMethodSignatureForSelector:(SEL)aSelector
{
    return [_targetClass instanceMethodSignatureForSelector:aSelector];
}

@end

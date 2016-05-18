//
//  BBCClassMethodSignatureProvider.m
//  Dispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCClassMethodSignatureProvider.h"
#import <objc/runtime.h>

@interface BBCClassMethodSignatureProvider ()

@property (nonatomic, strong) Class targetClass;
@property (nonatomic, strong) NSMutableArray<NSValue*>* allSelectors;

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
        _allSelectors = [NSMutableArray new];
        [self prepareSelectorsArrayForClass:_targetClass];
    }

    return self;
}

- (NSArray<NSValue*>*)selectors
{
    return _allSelectors;
}

- (NSMethodSignature*)targetInstanceMethodSignatureForSelector:(SEL)aSelector
{
    return [_targetClass instanceMethodSignatureForSelector:aSelector];
}

- (void)prepareSelectorsArrayForClass:(Class)aClass
{
    unsigned int count;
    Method* methods = class_copyMethodList(aClass, &count);

    for (unsigned int index = 0; index < count; index++) {
        Method method = methods[index];
        NSValue* selector = [NSValue valueWithPointer:method_getName(method)];
        [_allSelectors addObject:selector];
    }

    free(methods);

    Class superclass = class_getSuperclass(aClass);
    if (superclass && superclass != [NSObject class]) {
        [self prepareSelectorsArrayForClass:superclass];
    }
}

@end

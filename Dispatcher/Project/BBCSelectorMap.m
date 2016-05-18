//
//  BBCSelectorMap.m
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 17/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCSelectorMap.h"

const void* BBCPointerDictionaryRetainCallback(__unused CFAllocatorRef allocator, const void* value)
{
    return value;
}

void BBCPointerDictionaryReleaseCallback(__unused CFAllocatorRef allocator, __unused const void* value)
{
}

Boolean BBCPointerDictionaryEqualCallback(const void* value1, const void* value2)
{
    return value1 == value2;
}

CFHashCode BBCPointerDictionaryHashCallback(const void* value)
{
    return (CFHashCode)value;
}

#pragma mark -

@implementation BBCSelectorMap {
    CFDictionaryKeyCallBacks _callbacks;
    CFMutableDictionaryRef _storage;
}

+ (instancetype)map
{
    return [self new];
}

- (void)dealloc
{
    CFRelease(_storage);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _callbacks.retain = BBCPointerDictionaryRetainCallback;
        _callbacks.release = BBCPointerDictionaryReleaseCallback;
        _callbacks.hash = BBCPointerDictionaryHashCallback;
        _callbacks.equal = BBCPointerDictionaryEqualCallback;

        _storage = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &_callbacks, &kCFTypeDictionaryValueCallBacks);
    }

    return self;
}

- (void)setObject:(id)object forSelector:(SEL)aSelector
{
    CFDictionarySetValue(_storage, aSelector, (__bridge void*)object);
}

- (void)removeObjectForSelector:(SEL)aSelector
{
    CFDictionaryRemoveValue(_storage, aSelector);
}

- (nullable id)objectForSelector:(SEL)aSelector
{
    return (__bridge id)CFDictionaryGetValue(_storage, aSelector);
}

@end

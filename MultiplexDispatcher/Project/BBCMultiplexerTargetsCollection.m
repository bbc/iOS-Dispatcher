//
//  BBCMultiplexerTargetsCollection.m
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 16/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCMultiplexerTargetsCollection.h"

#pragma mark -

@interface BBCMultiplexerTargetsCollection ()

@property (nonatomic, assign) void** selectors;
@property (nonatomic, assign) NSUInteger selectorsBufferSize;
@property (nonatomic, assign) CFMutableDictionaryRef selectorTargetsMap;
@property (nonatomic, strong) NSMutableSet* storage;

@end

#pragma mark -

@implementation BBCMultiplexerTargetsCollection

#pragma mark Initialization

- (void)dealloc
{
    CFRelease(_selectorTargetsMap);
    free(_selectors);
}

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

- (instancetype)initWithSelectorsBuffer:(void**)buf bufferSize:(NSUInteger)size
{
    self = [super init];
    if (self) {
        _selectors = buf;
        _selectorsBufferSize = size;
        _storage = [NSMutableSet set];

        CFDictionaryKeyCallBacks keyCallbacks;
        keyCallbacks.retain = BBCPointerDictionaryRetainCallback;
        keyCallbacks.release = BBCPointerDictionaryReleaseCallback;
        keyCallbacks.hash = BBCPointerDictionaryHashCallback;
        keyCallbacks.equal = BBCPointerDictionaryEqualCallback;

        _selectorTargetsMap = CFDictionaryCreateMutable(kCFAllocatorDefault, size, &keyCallbacks, &kCFTypeDictionaryValueCallBacks);

        for (NSUInteger index = 0; index < size; index++) {
            CFMutableArrayRef array = CFArrayCreateMutable(kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
            CFDictionarySetValue(_selectorTargetsMap, buf[index], array);
            CFRelease(array);
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

    for (NSUInteger index = 0; index < _selectorsBufferSize; index++) {
        SEL selector = _selectors[index];

        CFMutableArrayRef array = (CFMutableArrayRef)CFDictionaryGetValue(_selectorTargetsMap, selector);
        CFIndex size = CFArrayGetCount(array);
        CFIndex index = CFArrayGetFirstIndexOfValue(array, CFRangeMake(0, size), (__bridge void*)target);
        CFArrayRemoveValueAtIndex(array, index);
    }
}

- (NSArray*)targetsRespondingToSelector:(SEL)aSelector
{
    return (__bridge NSArray*)CFDictionaryGetValue(_selectorTargetsMap, aSelector);
}

- (void)retainRespondingSelectorsForTarget:(id)target
{
    for (NSUInteger index = 0; index < _selectorsBufferSize; index++) {
        SEL selector = _selectors[index];

        if ([target respondsToSelector:selector]) {
            CFMutableArrayRef array = (CFMutableArrayRef)CFDictionaryGetValue(_selectorTargetsMap, selector);
            CFArrayAppendValue(array, (__bridge void*)target);
        }
    }
}

@end

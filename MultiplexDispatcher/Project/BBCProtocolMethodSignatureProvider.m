//
//  BBCProtocolMethodSignatureProvider.m
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCMethodDescription.h"
#import "BBCProtocolMethodSignatureProvider.h"
#import <objc/runtime.h>

@interface BBCProtocolMethodSignatureProvider ()

@property (nonatomic, strong) Protocol* targetProtocol;
@property (nonatomic, strong) NSMutableSet<BBCMethodDescription*>* methodDescriptions;
@property (nonatomic, strong) NSMutableSet<NSValue*>* allCachedSelectors;

@end

#pragma mark -

@implementation BBCProtocolMethodSignatureProvider

#pragma mark Initialization

- (instancetype)init
{
    return [self initWithProtocol:@protocol(NSObject)];
}

- (instancetype)initWithProtocol:(Protocol*)protocol
{
    self = [super init];
    if (self) {
        _targetProtocol = protocol;
        _methodDescriptions = [NSMutableSet set];
        _allCachedSelectors = [NSMutableSet set];

        [self prepareMethodDescriptionsForProtocol:_targetProtocol];
    }

    return self;
}

- (NSArray<NSValue*>*)selectors
{
    return _allCachedSelectors.allObjects;
}

- (NSMethodSignature*)targetInstanceMethodSignatureForSelector:(SEL)aSelector
{
    BBCMethodDescription* appropriateMethod;
    for (BBCMethodDescription* method in _methodDescriptions) {
        if (method.selector == aSelector) {
            appropriateMethod = method;
            break;
        }
    }

    return appropriateMethod.signature;
}

- (void)prepareMethodDescriptionsForProtocol:(Protocol*)protocol
{
    NSMutableSet* evaluated = [NSMutableSet set];
    [self prepareMethodDescriptionsForProtocol:protocol evaluatedProtocols:evaluated];
}

- (void)prepareMethodDescriptionsForProtocol:(Protocol*)protocol evaluatedProtocols:(NSMutableSet<Protocol*>*)evaluated
{
    if ([evaluated member:protocol]) {
        return;
    }

    NSSet<BBCMethodDescription*>* descriptions = [self methodDescriptionsForProtocol:protocol];
    [_methodDescriptions unionSet:descriptions];
    [evaluated addObject:protocol];

    [self prepareInheritedProtocolMethodDescriptionsForProtocol:protocol evaluatedProtocols:evaluated];
}

- (NSSet<BBCMethodDescription*>*)methodDescriptionsForProtocol:(Protocol*)protocol
{
    NSMutableSet<BBCMethodDescription*>* methodSignatures = [NSMutableSet new];
    [methodSignatures unionSet:[self methodDescriptionsForProtocol:protocol isRequiredMethod:NO]];
    [methodSignatures unionSet:[self methodDescriptionsForProtocol:protocol isRequiredMethod:YES]];
    return methodSignatures;
}

- (NSSet<BBCMethodDescription*>*)methodDescriptionsForProtocol:(Protocol*)protocol isRequiredMethod:(BOOL)required
{
    NSMutableSet<BBCMethodDescription*>* methodDescriptions = [NSMutableSet new];

    unsigned int count = 0;
    struct objc_method_description* methods = protocol_copyMethodDescriptionList(protocol, required, YES, &count);
    for (unsigned int index = 0; index < count; index++) {
        struct objc_method_description methodDescription = methods[index];
        BBCMethodDescription* description = [[BBCMethodDescription alloc] initWithObjCMethodDescription:methodDescription];
        [methodDescriptions addObject:description];
        [_allCachedSelectors addObject:[NSValue valueWithPointer:description.selector]];
    }

    free(methods);

    return methodDescriptions;
}

- (void)prepareInheritedProtocolMethodDescriptionsForProtocol:(Protocol*)protocol evaluatedProtocols:(NSMutableSet<Protocol*>*)evaluated
{
    unsigned int count = 0;
    Protocol __unsafe_unretained** protocols = protocol_copyProtocolList(protocol, &count);
    for (unsigned int index = 0; index < count; index++) {
        Protocol* inheritedProtocol = protocols[index];
        [self prepareMethodDescriptionsForProtocol:inheritedProtocol evaluatedProtocols:evaluated];
    }

    free(protocols);
}

@end

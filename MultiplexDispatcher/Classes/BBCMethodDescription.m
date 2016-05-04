//
//  BBCMethodDescription.m
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCMethodDescription.h"

@implementation BBCMethodDescription

- (instancetype)initWithObjCMethodDescription:(struct objc_method_description)methodDescription
{
    self = [super init];
    if (self) {
        _selector = methodDescription.name;
        _signature = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
    }

    return self;
}

@end

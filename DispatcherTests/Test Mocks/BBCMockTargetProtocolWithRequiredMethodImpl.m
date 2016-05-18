//
//  BBCMockTargetProtocolWithRequiredMethodImpl.m
//  Dispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCMockTargetProtocolWithRequiredMethodImpl.h"

@interface BBCMockTargetProtocolWithRequiredMethodImpl ()

@property (nonatomic, assign, readwrite) BOOL receievedMessage;

@end

@implementation BBCMockTargetProtocolWithRequiredMethodImpl

- (void)performRequiredMethod
{
    _receievedMessage = YES;
}

@end

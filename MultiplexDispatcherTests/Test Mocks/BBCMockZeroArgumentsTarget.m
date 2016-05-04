//
//  BBCMockZeroArgumentsTarget.m
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCMockZeroArgumentsTarget.h"

@interface BBCMockZeroArgumentsTarget ()

@property (nonatomic, assign, readwrite) BOOL receievedMessage;

@end

@implementation BBCMockZeroArgumentsTarget

- (void)zeroArgumentsMessage
{
    _receievedMessage = YES;
}

@end

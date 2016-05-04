//
//  BBCMockConformingProtocolTarget.m
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCMockConformingProtocolTarget.h"

@interface BBCMockConformingProtocolTarget ()

@property (nonatomic, assign, readwrite) BOOL notified;

@end

@implementation BBCMockConformingProtocolTarget

- (void)notify
{
    _notified = YES;
}

@end

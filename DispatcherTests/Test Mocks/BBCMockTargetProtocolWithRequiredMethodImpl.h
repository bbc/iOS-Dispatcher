//
//  BBCMockTargetProtocolWithRequiredMethodImpl.h
//  Dispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCMockTargetProtocolWithRequiredMethod.h"

@interface BBCMockTargetProtocolWithRequiredMethodImpl : NSObject<BBCMockTargetProtocolWithRequiredMethod>

@property (nonatomic, assign, readonly) BOOL receievedMessage;

@end

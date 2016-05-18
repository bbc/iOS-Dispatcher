//
//  BBCMockConformingProtocolTarget.h
//  Dispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCMockTargetProtocol.h"

@interface BBCMockConformingProtocolTarget : NSObject <BBCMockTargetProtocol>

@property (nonatomic, assign, readonly) BOOL notified;

@end

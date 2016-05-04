//
//  BBCMockZeroArgumentsTarget.h
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBCMockZeroArgumentsTarget : NSObject

@property (nonatomic, assign, readonly) BOOL receievedMessage;

- (void)zeroArgumentsMessage;

@end

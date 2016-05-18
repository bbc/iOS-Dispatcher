//
//  BBCMockTargetProtocolWithRequiredMethod.h
//  Dispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBCMockTargetProtocolWithRequiredMethod <NSObject>
@required

- (void)performRequiredMethod;

@end

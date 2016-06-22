//
//  BBCDispatcherMutatorTarget.h
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 22/06/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCDispatcher.h"

@interface BBCDispatcherMutatorTarget : NSObject

- (void)mutate:(BBCDispatcher<BBCDispatcherMutatorTarget *> *)dispatcher;

@end

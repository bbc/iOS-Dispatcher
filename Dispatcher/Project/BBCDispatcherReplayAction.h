//
//  BBCDispatcherReplayAction.h
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 03/06/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBCDispatcherReplayAction<__covariant Target> : NSObject

@property (nonatomic, strong, readonly, nullable) NSInvocation *invocation;

- (void)trackInvocation:(NSInvocation *)invocation NS_REQUIRES_SUPER;
- (void)replayWithTarget:(Target)target;

@end

NS_ASSUME_NONNULL_END

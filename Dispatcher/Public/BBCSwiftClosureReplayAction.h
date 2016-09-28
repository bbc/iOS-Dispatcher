//
//  BBCSwiftClosureReplayAction.h
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 15/06/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCDispatcherReplayAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBCSwiftClosureReplayAction : BBCDispatcherReplayAction

- (instancetype)initWithClosure:(nullable void(^)(id<NSObject> target))closure NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

//
//  BBCCachingMethodSignatureProvider.h
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 16/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCMethodSignatureProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBCCachingMethodSignatureProvider : NSObject<BBCMethodSignatureProvider>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMethodSignatureProvider:(id<BBCMethodSignatureProvider>)provider NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

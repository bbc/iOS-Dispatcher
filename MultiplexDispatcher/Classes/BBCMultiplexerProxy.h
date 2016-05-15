//
//  BBCMultiplexerProxy.h
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 06/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBCMultiplexerProxy : NSProxy

- (instancetype)initWithTargetClass:(Class)aClass;
- (instancetype)initWithTargetProtocol:(Protocol *)aProtocol;
- (instancetype)initWithTargetProtocolName:(NSString *)protocolName;

- (void)addTarget:(id)target;
- (void)removeTarget:(id)target;

@end

NS_ASSUME_NONNULL_END

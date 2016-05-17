//
//  BBCMultiplexerTargetsCollection.h
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 16/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBCMultiplexerTargetsCollection : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithSelectorsBuffer:(void* __nonnull * __nonnull)buf bufferSize:(NSUInteger)size NS_DESIGNATED_INITIALIZER;

- (void)addTarget:(id)target;
- (void)removeTarget:(id)target;
- (NSArray*)targetsRespondingToSelector:(SEL)aSelector;

@end

NS_ASSUME_NONNULL_END

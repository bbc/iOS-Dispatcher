//
//  BBCSelectorMap.h
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 17/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBCSelectorMap <__covariant ObjectType> : NSObject

+ (instancetype)map;

@property (nonatomic, readonly) NSArray<ObjectType> *allObjects;

- (void)setObject:(ObjectType)object forSelector:(SEL)aSelector;
- (void)removeObjectForSelector:(SEL)aSelector;
- (nullable ObjectType)objectForSelector:(SEL)aSelector;

@end

NS_ASSUME_NONNULL_END

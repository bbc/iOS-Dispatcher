//
//  BBCDispatcherTargetCollection.h
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 16/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBCDispatcherTargetCollection : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithSelectors:(NSArray<NSValue *> *)selectors NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSArray *allTargets;

- (void)addTarget:(id)target;
- (void)removeTarget:(id)target;
- (NSArray*)targetsRespondingToSelector:(SEL)aSelector;

@end

NS_ASSUME_NONNULL_END

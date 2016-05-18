//
//  BBCMethodDescription.h
//  Dispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBCMethodDescription : NSObject

@property (nonatomic, assign, readonly) SEL selector;
@property (nonatomic, strong, readonly) NSMethodSignature* signature;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithObjCMethodDescription:(struct objc_method_description)methodDescription NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

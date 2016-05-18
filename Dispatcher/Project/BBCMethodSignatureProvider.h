//
//  BBCMethodSignatureProvider.h
//  Dispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BBCMethodSignatureProvider <NSObject>
@required

@property (nonatomic, readonly) NSArray<NSValue*>* selectors;

- (nullable NSMethodSignature*)targetInstanceMethodSignatureForSelector:(SEL)aSelector;

@end

NS_ASSUME_NONNULL_END

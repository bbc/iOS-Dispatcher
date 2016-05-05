//
//  BBCMethodSignatureProvider.h
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BBCMethodSignatureProvider <NSObject>
@required

- (nullable NSMethodSignature*)targetInstanceMethodSignatureForSelector:(SEL)aSelector;

@end

NS_ASSUME_NONNULL_END
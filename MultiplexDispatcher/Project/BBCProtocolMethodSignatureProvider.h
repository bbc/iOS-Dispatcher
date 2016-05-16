//
//  BBCProtocolMethodSignatureProvider.h
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCMethodSignatureProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBCProtocolMethodSignatureProvider : NSObject <BBCMethodSignatureProvider>

- (instancetype)initWithProtocol:(Protocol*)protocol NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

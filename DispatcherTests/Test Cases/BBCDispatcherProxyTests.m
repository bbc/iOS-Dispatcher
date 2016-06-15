//
//  BBCDispatcherProxyTests.m
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 03/06/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "Dispatcher.h"
#import "BBCDispatcherReplayLastInvocationAction.h"
#import <XCTest/XCTest.h>

@interface BBCDispatcherProxyTests : XCTestCase
@end

#pragma mark -

@implementation BBCDispatcherProxyTests

#pragma mark Tests

- (void)testThatTheDefaultReplayActionUsesTheReplayLastInvocationAction
{
    BBCDispatcherProxy* sut = [[BBCDispatcherProxy alloc] init];
    XCTAssertEqual([BBCDispatcherReplayLastInvocationAction class], [sut.replayAction class]);
}

- (void)testAttemptingToSetTheReplayActionToNilChangesTheReplayActionToTheReplayLastInvocationAction
{
    BBCDispatcherProxy* sut = [[BBCDispatcherProxy alloc] init];
    sut.replayAction = nil;
    XCTAssertEqual([BBCDispatcherReplayLastInvocationAction class], [sut.replayAction class]);
}

@end

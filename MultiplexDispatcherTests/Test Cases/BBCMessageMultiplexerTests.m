//
//  BBCMessageMultiplexerTests.m
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCMessageMultiplexer.h"
#import "BBCMockConformingProtocolTarget.h"
#import "BBCMockNonConformingProtocolTarget.h"
#import "BBCMockTargetProtocolWithRequiredMethodImpl.h"
#import "BBCMockZeroArgumentsTarget.h"
#import <XCTest/XCTest.h>

@interface BBCMessageMultiplexerTests : XCTestCase
@end

#pragma mark -

@implementation BBCMessageMultiplexerTests

#pragma mark Tests

- (void)testClassDispatchPropogatesMessageToTarget
{
    BBCMessageMultiplexer<BBCMockZeroArgumentsTarget*>* sut = [[BBCMessageMultiplexer alloc] initWithTargetClass:[BBCMockZeroArgumentsTarget class]];
    BBCMockZeroArgumentsTarget* target = [BBCMockZeroArgumentsTarget new];
    [sut addTarget:target];
    [[sut dispatch] zeroArgumentsMessage];

    XCTAssertTrue(target.receievedMessage);
}

- (void)testAddingTargetAfterClassDispatchPropogatesPreviousMessageToTarget
{
    BBCMessageMultiplexer<BBCMockZeroArgumentsTarget*>* sut = [[BBCMessageMultiplexer alloc] initWithTargetClass:[BBCMockZeroArgumentsTarget class]];
    BBCMockZeroArgumentsTarget* target = [BBCMockZeroArgumentsTarget new];
    [[sut dispatch] zeroArgumentsMessage];
    [sut addTarget:target];

    XCTAssertTrue(target.receievedMessage);
}

- (void)testProtocolDispatchPropogatesMessageToOptionalConformer
{
    BBCMessageMultiplexer<id<BBCMockTargetProtocol> >* sut = [[BBCMessageMultiplexer alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocol)];
    BBCMockConformingProtocolTarget* target = [BBCMockConformingProtocolTarget new];
    [sut addTarget:target];
    [[sut dispatch] notify];

    XCTAssertTrue(target.notified);
}

- (void)testProtocolDispatchDoesNotCrashWhenAttemptingToPropogateMessageToNonConformer
{
    BBCMessageMultiplexer<id<BBCMockTargetProtocol> >* sut = [[BBCMessageMultiplexer alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocol)];
    BBCMockConformingProtocolTarget* target = [BBCMockConformingProtocolTarget new];
    BBCMockNonConformingProtocolTarget* altTarget = [BBCMockNonConformingProtocolTarget new];
    [sut addTarget:target];
    [sut addTarget:altTarget];

    XCTAssertNoThrow([[sut dispatch] notify]);
}

- (void)testProtocolDispatchDoesNotCrashWhenAddingNonConformingTargetAfterMessageDispatched
{
    BBCMessageMultiplexer<id<BBCMockTargetProtocol> >* sut = [[BBCMessageMultiplexer alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocol)];
    BBCMockNonConformingProtocolTarget* target = [BBCMockNonConformingProtocolTarget new];
    [[sut dispatch] notify];

    XCTAssertNoThrow([sut addTarget:target]);
}

- (void)testProtocolDispatchInvokesRequiredProtocolMethodOnTarget
{
    BBCMessageMultiplexer<id<BBCMockTargetProtocolWithRequiredMethod> >* sut = [[BBCMessageMultiplexer alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocolWithRequiredMethod)];
    BBCMockTargetProtocolWithRequiredMethodImpl* target = [BBCMockTargetProtocolWithRequiredMethodImpl new];
    [sut addTarget:target];
    [[sut dispatch] performRequiredMethod];

    XCTAssertTrue(target.receievedMessage);
}

- (void)testRemovingTargetThenDispatchingMessageDoesNotPropogateMessageToRemovedTarget
{
    BBCMessageMultiplexer<BBCMockZeroArgumentsTarget*>* sut = [[BBCMessageMultiplexer alloc] initWithTargetClass:[BBCMockZeroArgumentsTarget class]];
    BBCMockZeroArgumentsTarget* target = [BBCMockZeroArgumentsTarget new];
    [sut addTarget:target];
    [sut removeTarget:target];
    [[sut dispatch] zeroArgumentsMessage];

    XCTAssertFalse(target.receievedMessage);
}

@end

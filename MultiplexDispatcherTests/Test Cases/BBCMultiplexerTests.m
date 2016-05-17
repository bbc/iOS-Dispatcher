//
//  BBCMultiplexerTests.m
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCMultiplexer.h"
#import "BBCMockConformingProtocolTarget.h"
#import "BBCMockNonConformingProtocolTarget.h"
#import "BBCMockTargetProtocolWithRequiredMethodImpl.h"
#import "BBCMockZeroArgumentsTarget.h"
#import <XCTest/XCTest.h>

@interface BBCMultiplexerTests : XCTestCase
@end

#pragma mark -

@implementation BBCMultiplexerTests

#pragma mark Tests

- (void)testClassDispatchPropogatesMessageToTarget
{
    BBCMultiplexer<BBCMockZeroArgumentsTarget*>* sut = [[BBCMultiplexer alloc] initWithTargetClass:[BBCMockZeroArgumentsTarget class]];
    BBCMockZeroArgumentsTarget* target = [BBCMockZeroArgumentsTarget new];
    [sut addTarget:target];
    [[sut dispatch] zeroArgumentsMessage];

    XCTAssertTrue(target.receievedMessage);
}

- (void)testAddingTargetAfterClassDispatchPropogatesPreviousMessageToTarget
{
    BBCMultiplexer<BBCMockZeroArgumentsTarget*>* sut = [[BBCMultiplexer alloc] initWithTargetClass:[BBCMockZeroArgumentsTarget class]];
    BBCMockZeroArgumentsTarget* target = [BBCMockZeroArgumentsTarget new];
    [[sut dispatch] zeroArgumentsMessage];
    [sut addTarget:target];

    XCTAssertTrue(target.receievedMessage);
}

- (void)testProtocolDispatchPropogatesMessageToOptionalConformer
{
    BBCMultiplexer<id<BBCMockTargetProtocol> >* sut = [[BBCMultiplexer alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocol)];
    BBCMockConformingProtocolTarget* target = [BBCMockConformingProtocolTarget new];
    [sut addTarget:target];
    [[sut dispatch] notify];

    XCTAssertTrue(target.notified);
}

- (void)testProtocolDispatchDoesNotCrashWhenAttemptingToPropogateMessageToNonConformer
{
    BBCMultiplexer<id<BBCMockTargetProtocol> >* sut = [[BBCMultiplexer alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocol)];
    BBCMockConformingProtocolTarget* target = [BBCMockConformingProtocolTarget new];
    BBCMockNonConformingProtocolTarget* altTarget = [BBCMockNonConformingProtocolTarget new];
    [sut addTarget:target];
    [sut addTarget:altTarget];

    XCTAssertNoThrow([[sut dispatch] notify]);
}

- (void)testProtocolDispatchDoesNotCrashWhenAddingNonConformingTargetAfterMessageDispatched
{
    BBCMultiplexer<id<BBCMockTargetProtocol> >* sut = [[BBCMultiplexer alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocol)];
    BBCMockNonConformingProtocolTarget* target = [BBCMockNonConformingProtocolTarget new];
    [[sut dispatch] notify];

    XCTAssertNoThrow([sut addTarget:target]);
}

- (void)testProtocolDispatchInvokesRequiredProtocolMethodOnTarget
{
    BBCMultiplexer<id<BBCMockTargetProtocolWithRequiredMethod> >* sut = [[BBCMultiplexer alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocolWithRequiredMethod)];
    BBCMockTargetProtocolWithRequiredMethodImpl* target = [BBCMockTargetProtocolWithRequiredMethodImpl new];
    [sut addTarget:target];
    [[sut dispatch] performRequiredMethod];

    XCTAssertTrue(target.receievedMessage);
}

- (void)testRemovingTargetThenDispatchingMessageDoesNotPropogateMessageToRemovedTarget
{
    BBCMultiplexer<BBCMockZeroArgumentsTarget*>* sut = [[BBCMultiplexer alloc] initWithTargetClass:[BBCMockZeroArgumentsTarget class]];
    BBCMockZeroArgumentsTarget* target = [BBCMockZeroArgumentsTarget new];
    [sut addTarget:target];
    [sut removeTarget:target];
    [[sut dispatch] zeroArgumentsMessage];

    XCTAssertFalse(target.receievedMessage);
}

- (void)testPerformanceWhenDispatchingMessageWithClassTargets
{
    BBCMultiplexer<BBCMockZeroArgumentsTarget*>* sut = [[BBCMultiplexer alloc] initWithTargetClass:[BBCMockZeroArgumentsTarget class]];
    [self prepareMultiplexer:sut forPerformanceTestWithConcreteTargetClass:[BBCMockZeroArgumentsTarget class]];

    [self measureBlock:^{
        [[sut dispatch] zeroArgumentsMessage];
    }];
}

- (void)testPerformanceWhenDistachingMessageWithProtocolTargetsWhereTargetsImplementsRequiredMethod
{
    BBCMultiplexer<id<BBCMockTargetProtocolWithRequiredMethod> >* sut = [[BBCMultiplexer alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocolWithRequiredMethod)];
    [self prepareMultiplexer:sut forPerformanceTestWithConcreteTargetClass:[BBCMockTargetProtocolWithRequiredMethodImpl class]];

    [self measureBlock:^{
        [[sut dispatch] performRequiredMethod];
    }];
}

- (void)testPerformanceWhenDisatchingMesssageWithProtocolTargetsWhereTargetsDoNotImplementOptionalMethod
{
    [self measureMetrics:[[self class] defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        BBCMultiplexer<id<BBCMockTargetProtocol> >* sut = [[BBCMultiplexer alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocol)];
        [self prepareMultiplexer:sut forPerformanceTestWithConcreteTargetClass:[BBCMockNonConformingProtocolTarget class]];
        
        [self startMeasuring];
        [[sut dispatch] notify];
        [self stopMeasuring];
    }];
}

- (void)testPerformanceWhenDispatchingMessageWithProtocolTargetsWhereTargetImplementsOptionalMethod
{
    BBCMultiplexer<id<BBCMockTargetProtocol> >* sut = [[BBCMultiplexer alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocol)];
    [self prepareMultiplexer:sut forPerformanceTestWithConcreteTargetClass:[BBCMockConformingProtocolTarget class]];

    [self measureBlock:^{
        [[sut dispatch] notify];
    }];
}

- (void)prepareMultiplexer:(BBCMultiplexer*)multiplexer forPerformanceTestWithConcreteTargetClass:(Class)targetClass
{
    NSUInteger targetsCount = 1E6;
    for (NSUInteger counter = 0; counter < targetsCount; counter++) {
        id target = [targetClass new];
        [multiplexer addTarget:target];
    }
}

@end

//
//  BBCDispatcherTests.m
//  Dispatcher
//
//  Created by Thomas Sherwood on 03/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCDispatcherMutatorTarget.h"
#import "BBCMockConformingProtocolTarget.h"
#import "BBCMockNonConformingProtocolTarget.h"
#import "BBCMockTargetProtocolWithRequiredMethodImpl.h"
#import "BBCMockZeroArgumentsTarget.h"
#import "Dispatcher.h"
#import <XCTest/XCTest.h>

@interface BBCDispatcherTests : XCTestCase
@end

#pragma mark -

@implementation BBCDispatcherTests

#pragma mark Tests

- (void)testClassDispatchPropogatesMessageToTarget
{
    BBCDispatcher<BBCMockZeroArgumentsTarget*>* sut = [[BBCDispatcher alloc] initWithTargetClass:[BBCMockZeroArgumentsTarget class]];
    BBCMockZeroArgumentsTarget* target = [BBCMockZeroArgumentsTarget new];
    [sut addTarget:target];
    [[sut dispatch] zeroArgumentsMessage];

    XCTAssertTrue(target.receievedMessage);
}

- (void)testAddingTargetAfterClassDispatchPropogatesPreviousMessageToTarget
{
    BBCDispatcher<BBCMockZeroArgumentsTarget*>* sut = [[BBCDispatcher alloc] initWithTargetClass:[BBCMockZeroArgumentsTarget class]];
    BBCMockZeroArgumentsTarget* target = [BBCMockZeroArgumentsTarget new];
    [[sut dispatch] zeroArgumentsMessage];
    [sut addTarget:target];

    XCTAssertTrue(target.receievedMessage);
}

- (void)testAddingTargetAfterClassDispatchUsingCustomReplayActionInvokesReplayBlockWithTarget
{
    __block BBCMockZeroArgumentsTarget* receievedTarget;
    BBCDispatcher<BBCMockZeroArgumentsTarget*>* sut = [[BBCDispatcher alloc] initWithTargetClass:[BBCMockZeroArgumentsTarget class] replayBlock:^(BBCMockZeroArgumentsTarget* _Nonnull target, __unused NSInvocation* _Nonnull invocation) {
        receievedTarget = target;
    }];

    BBCMockZeroArgumentsTarget* target = [BBCMockZeroArgumentsTarget new];
    [[sut dispatch] zeroArgumentsMessage];
    [sut addTarget:target];

    XCTAssertEqual(receievedTarget, target);
}

- (void)testProtocolDispatchPropogatesMessageToOptionalConformer
{
    BBCDispatcher<id<BBCMockTargetProtocol> >* sut = [[BBCDispatcher alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocol)];
    BBCMockConformingProtocolTarget* target = [BBCMockConformingProtocolTarget new];
    [sut addTarget:target];
    [[sut dispatch] notify];

    XCTAssertTrue(target.notified);
}

- (void)testProtocolDispatchDoesNotCrashWhenAttemptingToPropogateMessageToNonConformer
{
    BBCDispatcher<id<BBCMockTargetProtocol> >* sut = [[BBCDispatcher alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocol)];
    BBCMockConformingProtocolTarget* target = [BBCMockConformingProtocolTarget new];
    BBCMockNonConformingProtocolTarget* altTarget = [BBCMockNonConformingProtocolTarget new];
    [sut addTarget:target];
    [sut addTarget:altTarget];

    XCTAssertNoThrow([[sut dispatch] notify]);
}

- (void)testProtocolDispatchDoesNotCrashWhenAddingNonConformingTargetAfterMessageDispatched
{
    BBCDispatcher<id<BBCMockTargetProtocol> >* sut = [[BBCDispatcher alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocol)];
    BBCMockNonConformingProtocolTarget* target = [BBCMockNonConformingProtocolTarget new];
    [[sut dispatch] notify];

    XCTAssertNoThrow([sut addTarget:target]);
}

- (void)testProtocolDispatchInvokesRequiredProtocolMethodOnTarget
{
    BBCDispatcher<id<BBCMockTargetProtocolWithRequiredMethod> >* sut = [[BBCDispatcher alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocolWithRequiredMethod)];
    BBCMockTargetProtocolWithRequiredMethodImpl* target = [BBCMockTargetProtocolWithRequiredMethodImpl new];
    [sut addTarget:target];
    [[sut dispatch] performRequiredMethod];

    XCTAssertTrue(target.receievedMessage);
}

- (void)testAddingTargetAfterProtocolDispatchUsingCustomReplayActionInvokesReplayBlockWithTarget
{
    __block id<BBCMockTargetProtocolWithRequiredMethod> receievedTarget;
    BBCDispatcher<id<BBCMockTargetProtocolWithRequiredMethod> >* sut = [[BBCDispatcher alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocolWithRequiredMethod) replayBlock:^(id<BBCMockTargetProtocolWithRequiredMethod> _Nonnull target, __unused NSInvocation* _Nonnull invocation) {
        receievedTarget = target;
    }];

    BBCMockTargetProtocolWithRequiredMethodImpl* target = [BBCMockTargetProtocolWithRequiredMethodImpl new];
    [[sut dispatch] performRequiredMethod];
    [sut addTarget:target];

    XCTAssertEqual(receievedTarget, target);
}

- (void)testRemovingTargetThenDispatchingMessageDoesNotPropogateMessageToRemovedTarget
{
    BBCDispatcher<BBCMockZeroArgumentsTarget*>* sut = [[BBCDispatcher alloc] initWithTargetClass:[BBCMockZeroArgumentsTarget class]];
    BBCMockZeroArgumentsTarget* target = [BBCMockZeroArgumentsTarget new];
    [sut addTarget:target];
    [sut removeTarget:target];
    [[sut dispatch] zeroArgumentsMessage];

    XCTAssertFalse(target.receievedMessage);
}

- (void)testAddingTargetIndicatesDispatcherContainsTarget
{
    BBCDispatcher<BBCMockZeroArgumentsTarget*>* sut = [[BBCDispatcher alloc] initWithTargetClass:[BBCMockZeroArgumentsTarget class]];
    BBCMockZeroArgumentsTarget* target = [BBCMockZeroArgumentsTarget new];
    [sut addTarget:target];

    XCTAssertTrue([sut containsTarget:target]);
}

- (void)testAddingTargetWhileDispatcherIsMessagingExistingTargetsDoesNotCrash
{
    BBCDispatcher<BBCDispatcherMutatorTarget*>* sut = [[BBCDispatcher alloc] initWithTargetClass:[BBCDispatcherMutatorTarget class]];
    [sut addTarget:[BBCDispatcherMutatorTarget new]];
    [sut addTarget:[BBCDispatcherMutatorTarget new]];

    XCTAssertNoThrow([[sut dispatch] mutate:sut]);
}

- (void)testPerformanceWhenDispatchingMessageWithClassTargets
{
    [self measureMetrics:[[self class] defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        BBCDispatcher<BBCMockZeroArgumentsTarget*>* sut = [[BBCDispatcher alloc] initWithTargetClass:[BBCMockZeroArgumentsTarget class]];
        [self prepareMultiplexer:sut forPerformanceTestWithConcreteTargetClass:[BBCMockZeroArgumentsTarget class]];

        [self startMeasuring];
        [[sut dispatch] zeroArgumentsMessage];
        [self stopMeasuring];
    }];
}

- (void)testPerformanceWhenDistachingMessageWithProtocolTargetsWhereTargetsImplementsRequiredMethod
{
    [self measureMetrics:[[self class] defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        BBCDispatcher<id<BBCMockTargetProtocolWithRequiredMethod> >* sut = [[BBCDispatcher alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocolWithRequiredMethod)];
        [self prepareMultiplexer:sut forPerformanceTestWithConcreteTargetClass:[BBCMockTargetProtocolWithRequiredMethodImpl class]];

        [self startMeasuring];
        [[sut dispatch] performRequiredMethod];
        [self stopMeasuring];
    }];
}

- (void)testPerformanceWhenDispatchingMessageWithProtocolTargetsWhereTargetsDoNotImplementOptionalMethod
{
    [self measureMetrics:[[self class] defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        BBCDispatcher<id<BBCMockTargetProtocol> >* sut = [[BBCDispatcher alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocol)];
        [self prepareMultiplexer:sut forPerformanceTestWithConcreteTargetClass:[BBCMockNonConformingProtocolTarget class]];

        [self startMeasuring];
        [[sut dispatch] notify];
        [self stopMeasuring];
    }];
}

- (void)testPerformanceWhenDispatchingMessageWithProtocolTargetsWhereTargetImplementsOptionalMethod
{
    [self measureMetrics:[[self class] defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        BBCDispatcher<id<BBCMockTargetProtocol> >* sut = [[BBCDispatcher alloc] initWithTargetProtocol:@protocol(BBCMockTargetProtocol)];
        [self prepareMultiplexer:sut forPerformanceTestWithConcreteTargetClass:[BBCMockConformingProtocolTarget class]];

        [self startMeasuring];
        [[sut dispatch] notify];
        [self stopMeasuring];
    }];
}

- (void)prepareMultiplexer:(BBCDispatcher*)multiplexer forPerformanceTestWithConcreteTargetClass:(Class)targetClass
{
    NSUInteger targetsCount = 1E5;
    for (NSUInteger counter = 0; counter < targetsCount; counter++) {
        id target = [targetClass new];
        [multiplexer addTarget:target];
    }
}

@end

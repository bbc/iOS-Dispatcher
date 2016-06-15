//
//  DispatcherTests.swift
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 06/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

import Dispatcher
import XCTest

class DispatcherTests: XCTestCase {
    
    // MARK: Tests
    
    func testForwardingMessageForClassType() {
        var sut = Dispatcher(class: BBCMockZeroArgumentsTarget.self)
        let target = BBCMockZeroArgumentsTarget()
        sut.addTarget(target)
        sut.dispatch().zeroArgumentsMessage()
        
        XCTAssertTrue(target.receievedMessage)
    }
    
    func testForwardingMessageForProtocolType() {
        var sut: Dispatcher<BBCMockTargetProtocol> = Dispatcher(protocol: BBCMockTargetProtocol.self)
        let target = BBCMockConformingProtocolTarget()
        sut.addTarget(target)
        sut.dispatch().notify?()
        
        XCTAssertTrue(target.notified)
    }
    
    func testRemovingTargetThenDispatchingMessageDoesNotNotifyTarget() {
        var sut = Dispatcher(class: BBCMockZeroArgumentsTarget.self)
        let target = BBCMockZeroArgumentsTarget()
        sut.addTarget(target)
        sut.removeTarget(target)
        sut.dispatch().zeroArgumentsMessage()
        
        XCTAssertFalse(target.receievedMessage)
    }
    
    func testInitializingDispatcherForClassTargetsWithReplayBlockInvokesBlockWithNewTarget() {
        var receievedTarget: BBCMockZeroArgumentsTarget!
        var sut = Dispatcher(class: BBCMockZeroArgumentsTarget.self, replayBlock: { receievedTarget = $0 } )
        let target = BBCMockZeroArgumentsTarget()
        sut.addTarget(target)
        
        XCTAssertEqual(target, receievedTarget)
    }
    
    func testInitializingDispatcherForProtocolTargetsWithReplayBlockInvokesBlockWithNewTarget() {
        var receievedTarget: BBCMockTargetProtocol!
        var sut: Dispatcher<BBCMockTargetProtocol> = Dispatcher(protocol: BBCMockTargetProtocol.self, replayBlock: { receievedTarget = $0 } )
        let target = BBCMockConformingProtocolTarget()
        sut.addTarget(target)
        
        XCTAssertTrue(target === receievedTarget)
    }
    
}

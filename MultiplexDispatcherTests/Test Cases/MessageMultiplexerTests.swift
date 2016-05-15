//
//  MessageMultiplexerTests.swift
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 06/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

import XCTest

class MessageMultiplexerTests: XCTestCase {
    
    // MARK: Tests
    
    func testForwardingMessageForClassType() {
        var sut = MessageMultiplexer(class: BBCMockZeroArgumentsTarget.self)
        let target = BBCMockZeroArgumentsTarget()
        sut.addTarget(target)
        sut.dispatch().zeroArgumentsMessage()
        
        XCTAssertTrue(target.receievedMessage)
    }
    
    func testForwardingMessageForProtocolType() {
        var sut: MessageMultiplexer<BBCMockTargetProtocol> = MessageMultiplexer(protocol: BBCMockTargetProtocol.self)
        let target = BBCMockConformingProtocolTarget()
        sut.addTarget(target)
        sut.dispatch().notify?()
        
        XCTAssertTrue(target.notified)
    }
    
    func testRemovingTargetThenDispatchingMessageDoesNotNotifyTarget() {
        var sut = MessageMultiplexer(class: BBCMockZeroArgumentsTarget.self)
        let target = BBCMockZeroArgumentsTarget()
        sut.addTarget(target)
        sut.removeTarget(target)
        sut.dispatch().zeroArgumentsMessage()
        
        XCTAssertFalse(target.receievedMessage)
    }
    
}

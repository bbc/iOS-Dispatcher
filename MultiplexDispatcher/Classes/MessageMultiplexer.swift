//
//  MessageMultiplexer.swift
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 06/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

import Foundation
import ObjectiveC

public class MessageMultiplexer<Target: NSObjectProtocol>: NSObject {
    
    private let proxy: BBCMultiplexerProxy
    
    public init(class aClass: Target.Type) {
        proxy = BBCMultiplexerProxy(targetClass: aClass)
    }
    
    public init(protocol aProtocol: Protocol) {
        proxy = BBCMultiplexerProxy(targetProtocolName: NSStringFromProtocol(aProtocol))
    }
    
    public func addTarget(target: Target) {
        proxy.addTarget(target)
    }
    
    public func removeTarget(target: Target) {
        proxy.removeTarget(target)
    }
    
    public func dispatch() -> Target {
        guard let target = proxy as? Target else {
            fatalError("Proxy class not configured to mimic \(Target.self)")
        }
        
        return target
    }

}

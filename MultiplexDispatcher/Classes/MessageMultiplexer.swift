//
//  MessageMultiplexer.swift
//  MultiplexDispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 06/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

import Foundation

public struct MessageMultiplexer<Target: NSObjectProtocol> {
    
    // MARK: Properties
    
    private let proxy: BBCMultiplexerProxy
    
    
    // MARK: Initialization
    
    public init(class aClass: Target.Type) {
        proxy = BBCMultiplexerProxy(targetClass: aClass)
    }
    
    public init(protocol aProtocol: Protocol) {
        proxy = BBCMultiplexerProxy(targetProtocolName: NSStringFromProtocol(aProtocol))
    }
    
    
    // MARK: Dispatch Management
    
    public mutating func addTarget(target: Target) {
        proxy.addTarget(target)
    }
    
    public mutating func removeTarget(target: Target) {
        proxy.removeTarget(target)
    }
    
    public nonmutating func dispatch() -> Target {
        guard let target = proxy as? Target else {
            fatalError("Proxy class not configured to mimic \(Target.self)")
        }
        
        return target
    }

}

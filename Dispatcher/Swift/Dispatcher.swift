//
//  Dispatcher.swift
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 06/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

import Foundation

public struct Dispatcher<Target: NSObjectProtocol> {
    
    public typealias ReplayBlock = (Target) -> Void
    
    
    // MARK: Properties
    
    private let proxy: BBCDispatcherProxy
    private let target: Target
    
    
    // MARK: Initialization
    
    public init(class aClass: Target.Type, replayBlock: ReplayBlock? = nil) {
        self.init(proxy: BBCDispatcherProxy(targetClass: aClass), replayBlock: replayBlock)
    }
    
    public init(protocol aProtocol: Protocol, replayBlock: ReplayBlock? = nil) {
        self.init(proxy: BBCDispatcherProxy(targetProtocol: aProtocol), replayBlock: replayBlock)
    }
    
    init(proxy: BBCDispatcherProxy, replayBlock: ReplayBlock?) {
        guard let target = proxy as? Target else {
            fatalError("Proxy class not configured to mimic \(Target.self)")
        }
        
        self.proxy = proxy
        self.target = target
        
        if let replayBlock = replayBlock {
            proxy.replayAction = BBCSwiftClosureReplayAction { target in
                if let target = target as? Target {
                    replayBlock(target)
                }
            }
        }
    }
    
    
    // MARK: Dispatch Management
    
    public mutating func addTarget(target: Target) {
        proxy.addTarget(target)
    }
    
    public mutating func removeTarget(target: Target) {
        proxy.removeTarget(target)
    }
    
    public func dispatch() -> Target {
        return target
    }

}

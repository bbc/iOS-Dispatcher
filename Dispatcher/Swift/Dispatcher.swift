//
//  Dispatcher.swift
//  Dispatcher
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 06/05/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

import Foundation

public struct Dispatcher<Target: NSObjectProtocol> {
    
    // MARK: Properties
    
    private let proxy: BBCDispatcherProxy
    private let target: Target
    
    
    // MARK: Initialization
    
    public init(class aClass: Target.Type) {
        self.init(proxy: BBCDispatcherProxy(targetClass: aClass))
    }
    
    public init(protocol aProtocol: Protocol) {
        self.init(proxy: BBCDispatcherProxy(targetProtocol: aProtocol))
    }
    
    init(proxy: BBCDispatcherProxy) {
        self.proxy = proxy
        
        guard let target = proxy as? Target else {
            fatalError("Proxy class not configured to mimic \(Target.self)")
        }
        
        self.target = target
    }
    
    
    // MARK: Dispatch Management
    
    public mutating func addTarget(target: Target) {
        proxy.addTarget(target)
    }
    
    public mutating func removeTarget(target: Target) {
        proxy.removeTarget(target)
    }
    
    public nonmutating func dispatch() -> Target {
        return target
    }

}

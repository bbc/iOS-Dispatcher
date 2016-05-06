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
    
    private let multiplexer: BBCMessageMultiplexer
    
    public init(class aClass: Target.Type) {
        multiplexer = BBCMessageMultiplexer(targetClass: aClass)
    }    
    
    public func addTarget(target: Target) {
        multiplexer.addTarget(target)
    }
    
    public func removeTarget(target: Target) {
        
    }
    
    public func dispatch() -> Target {
        guard let target = multiplexer.dispatch() as? Target else {
            fatalError("Proxy class not configured to mimic \(Target.self)")
        }
        
        return target
    }

}

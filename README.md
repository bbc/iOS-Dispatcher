# iOS Multiplex Dispatcher
Message multiplexing component that aids in reducing boilerplate when implementing the observer pattern within your iOS application by:

- Transparently maintaining an aggregation of observers
- Forwarding messages onto each observer by sending the desired message to the multiplexer
- Managing optional protocol methods, only notifying observers with implementations

The multiplexer supports class and protocol aggregations - just initialize one with the desired level of abstraction you require.

## Usage
Assuming `BBCSomeObserver` is a protocol with a zero-arguments `notify` method, and `BBCSomeConcreteObserver` conforms to it:

**Objective-C**

```objc
BBCMessageMultiplexer* multiplexer = [[BBCMessageMultiplexer alloc] initWithTargetProtocol:@protocol(BBCSomeObserver)];
BBCSomeConcreteObserver* target = ...
[multiplexer addTarget:target];
[[multiplexer dispatch] notify];
```

**Swift**
```swift
var multiplexer: MessageMultiplexer<BBCMockTargetProtocol> = MessageMultiplexer(protocol: BBCSomeObserver.self)
let target: BBCSomeConcreteObserver = ...
sut.addTarget(target)
sut.dispatch().notify()
```

You can also dispatch messages that accept arguments - just declare them in your class or protocol and invoke them as you would normally.

**Swift Note**

When initializing the multiplexer with an Objective-C protocol, you need to explicitly declare the generic argument. As of Swift 2.2 we can't downcast `Target.Type` into a `Protocol` without causing the compiler to implode.

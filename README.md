# iOS Dispatcher
Message multiplexing component that aids in reducing boilerplate when implementing the observer pattern within your iOS application by:

- Transparently maintaining an aggregation of observers
- Forwarding messages onto each observer by sending the desired message to the multiplexer
- Managing optional protocol methods, only notifying observers with implementations

The multiplexer supports class and protocol aggregations - just initialize one with the desired level of abstraction you require.

## Usage
Assuming `BBCSomeObserver` is a protocol with a zero-arguments `notify` method, and `BBCSomeConcreteObserver` conforms to it:

**Objective-C**
```objc
BBCDispatcher* dispatcher = [[BBCDispatcher alloc] initWithTargetProtocol:@protocol(BBCSomeObserver)];
BBCSomeConcreteObserver* target = ...
[dispatcher addTarget:target];
[[dispatcher dispatch] notify];
```

**Swift**
```swift
var dispatcher: Dispatcher<BBCSomeObserver> = Dispatcher(protocol: BBCSomeObserver.self)
let target: BBCSomeConcreteObserver = ...
dispatcher.addTarget(target)
dispatcher.dispatch().notify()
```

You can also dispatch messages that accept arguments - just declare them in your class or protocol and invoke them as you would normally.

***Swift Note***

When initializing the multiplexer with an Objective-C protocol, you need to explicitly declare the generic argument. As of Swift 2.2 we can't downcast `Target.Type` into a `Protocol` without causing the compiler to implode.

## Message Replaying

By default, a `Dispatcher` will retain the last invocation it receieves for replaying onto newly-added targets. For instance, in the examples below the target will receieve a `performAction` message but will not receieve the `notify` message:

**Objective-C**
```objc
BBCDispatcher* dispatcher = [[BBCDispatcher alloc] initWithTargetProtocol:@protocol(BBCSomeObserver)];
BBCSomeConcreteObserver* target = ...
[[dispatcher dispatch] notify];
[[dispatcher dispatch] performAction];
[dispatcher addTarget:target];
```

**Swift**
```swift
var dispatcher: Dispatcher<BBCSomeObserver> = Dispatcher(protocol: BBCSomeObserver.self)
let target: BBCSomeConcreteObserver = ...
dispatcher.dispatch().notify()
dispatcher.dispatch().performAction()
dispatcher.addTarget(target)
```

You can customise this behaviour by providing a block to the dispatcher. When a new target is added, the block is invoked with the target and the last `NSInvocation` receieved by the dispatcher:

**Objective-C**
```objc
BBCDispatcher* dispatcher = [[BBCDispatcher alloc] initWithTargetProtocol:@protocol(BBCSomeObserver) replayBlock:^(id<BBCSomeObserver> target, NSInvocation *lastInvocation) {
  // Custom replay logic here, for example...
  if(target.condition) {
    [lastInvocation invokeWithTarget:target];
  }
}];

BBCSomeConcreteObserver* target = ...
[dispatcher addTarget:target];  // Block will be invoked now
```

**Swift**
```swift
var dispatcher: Dispatcher<BBCSomeObserver> = Dispatcher(protocol: BBCSomeObserver.self) { target in
  // Custom replay logic here, for example...
  if target.condition {
    target.performSomeOtherAction()
  }
}

let target: BBCSomeConcreteObserver = ...
dispatcher.addTarget(target)  // Block will be invoked now
```

***Swift Note***

`NSInvocation` isn't available in Swift, so replay blocks are only provided with the target.

//
//  Observable.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import Foundation

final class Observable<Value> {
    struct Observer<Value> {
        weak var observer: AnyObject?
        let block: (Value) -> Void
    }

    private var observers = [Observer<Value>]()

    public var value: Value {
        didSet { }
    }

    public init(_ value: Value) {
        self.value = value
    }

    public func observe(on observer: AnyObject, observerBlock: @escaping (Value) -> Void) {
        observers.append(Observer(observer: observer, block: observerBlock))
        observerBlock(self.value)
    }

    public func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }

    public func notiyObservers() {
        for observer in observers {
            DispatchQueue.main.async { observer.block(self.value) }
        }
    }
}

//
//  Observable.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import Foundation

final class Observable<V> {

    struct Observer<V> {
        weak var observer: AnyObject?
        let block: (V) -> Void
    }

    private var observers = [Observer<V>]()

    public var value: V {
        didSet { notifyObservers() }
    }

    public init(_ value: V) {
        self.value = value
    }

    public func observe(on observer: AnyObject, observerBlock: @escaping (V) -> Void) {
        observers.append(Observer(observer: observer, block: observerBlock))
    }

    public func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }

    private func notifyObservers() {
        for observer in observers {
            DispatchQueue.main.async { observer.block(self.value) }
        }
    }
}

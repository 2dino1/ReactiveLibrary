//
//  SignalHolderMock.swift
//  
//
//  Created by Sima Vlad Grigore on 07/12/2021.
//

import Foundation
@testable import ReactiveLibrary

internal final class SignalHolderMock: NSObject{
    @objc dynamic internal var stringPropertyToChange: String = "Null"
    @objc dynamic internal var intPropertyToChange: Int = 2
}

extension SignalHolderMock {
    internal func signal() -> Signal<String, Error> {
        let (sink, signal) = Signal<String, Error>.createPipe()
        let observer = KeyValueObserver<String>(object: self, keyPath: #keyPath(stringPropertyToChange)) { result in
            sink(.success(result))
        }
        signal.updateObservers(with: observer)
        return signal
    }
    
    internal func signal() -> Signal<Int, Error> {
        let (sink, signal) = Signal<Int, Error>.createPipe()
        let observer = KeyValueObserver<Int>(object: self, keyPath: #keyPath(intPropertyToChange)) { result in
            sink(.success(result))
        }
        signal.updateObservers(with: observer)
        return signal
    }
}

//
//  SignalHolderMock.swift
//  
//
//  Created by Sima Vlad Grigore on 07/12/2021.
//

import Foundation
@testable import ReactiveLibrary

internal final class SignalHolderMock: NSObject {
    @objc internal var propertyToChange: String = "Null"
}

extension SignalHolderMock {
    internal func signal() -> Signal<String, Error> {
        let (sink, signal) = Signal<String, Error>.createPipe()
        let observer = KeyValueObserver<String>(object: self, keyPath: #keyPath(propertyToChange)) { result in
            sink(.success(result))
        }
        
        signal.updateObservers(with: observer)
        return signal
    }
}

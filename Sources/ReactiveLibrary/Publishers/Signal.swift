//
//  Signal.swift
//  
//
//  Created by Sima Vlad Grigore on 07/12/2021.
//

import Foundation

public final class Signal<InputType, ErrorType> where ErrorType: Error {
    // MARK: - Properties
    public typealias SignalResult = Result<InputType, ErrorType>
    public typealias SignalResultCompletion = (Result<InputType, ErrorType>) -> Void
    
    private var callbacks: [SignalResultCompletion] = []
    private  var observers: [Any] = []
    
    // MARK: - Public Methods
    public static func createPipe() -> (SignalResultCompletion, Signal<InputType, ErrorType>) {
        let signal = Signal()
        let callback: (SignalResult) -> Void = { [weak signal] value in signal?.send(value: value) }
        return (callback, signal)
    }
    
    public func onResult(completion: @escaping SignalResultCompletion) {
        callbacks.append(completion)
    }
    
    public func updateObservers(with observer: Any) {
        observers.append(observer)
    }
    
    // MARK: - Private Methods
    private func send(value: SignalResult) {
        for callback in callbacks {
            callback(value)
        }
    }
}

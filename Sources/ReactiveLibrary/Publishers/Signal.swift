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
    
    private typealias Token = UUID
    private var callbacks: [Token: SignalResultCompletion] = [:]
    private var observers: [Any] = []
    
    // MARK: - Public Methods
    public static func createPipe() -> (SignalResultCompletion, Signal<InputType, ErrorType>) {
        let signal = Signal()
        let callback: (SignalResult) -> Void = { [weak signal] value in signal?.send(value: value) }
        return (callback, signal)
    }
    
    public func subscribe(completion: @escaping SignalResultCompletion) -> Disposable {
        let token = UUID()
        callbacks.updateValue(completion, forKey: token)
        return Disposable {
            self.callbacks.removeValue(forKey: token)
        }
    }
    
    public func updateObservers(with observer: Any) {
        observers.append(observer)
    }
    
    public func map<OutputType>(transform: @escaping (InputType) -> OutputType) -> Signal<OutputType, ErrorType> {
        let (sink, signal) = Signal<OutputType, ErrorType>.createPipe()
        
        let disposable = subscribe { (result) in
            let transformedValue = result.map(transform)
            sink(transformedValue)
        }
        updateObservers(with: self)
        
        return signal
    }
    
    // MARK: - Private Methods
    private func send(value: SignalResult) {
        for callback in callbacks.values {
            callback(value)
        }
    }
}

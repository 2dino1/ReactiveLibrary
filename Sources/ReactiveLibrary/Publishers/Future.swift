//
//  Future.swift
//  
//
//  Created by Sima Vlad Grigore on 06/12/2021.
//

import Foundation

public final class Future<InputType, ErrorType> where ErrorType: Error {
    // MARK: - Properties
    public typealias Promise = ((Result<InputType, ErrorType>) -> Void)
    
    private var callbacks: [Promise] = []
    private var cachedResult: Result<InputType, ErrorType>?
    
    // MARK: - Init
    public init(compute: (@escaping Promise) -> Void) {
        compute(self.send)
    }
    
    // MARK: - Public Methods
    public func onResult(completion: @escaping Promise) {
        if let result = cachedResult {
            completion(result)
        } else {
            callbacks.append(completion)
        }
    }
    
    // TODO: This should convert the output into a Future<ConvertedType, Error> (from the transform closure)
    public func flatMap<ConvertedType>(transform: @escaping (InputType) -> (ConvertedType)) -> Future<ConvertedType, ErrorType> {
        return Future<ConvertedType, ErrorType> { promise in
            self.onResult { (result) in
                switch result {
                case .success(let value):
                    promise(.success(transform(value)))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func send(value: Result<InputType, ErrorType>) {
        assert(cachedResult == nil)
        
        cachedResult = value
        for callback in callbacks {
            callback(value)
        }
    }
}

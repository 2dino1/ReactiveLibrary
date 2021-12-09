//
//  FutureTests.swift
//  
//
//  Created by Sima Vlad Grigore on 06/12/2021.
//

import XCTest
@testable import ReactiveLibrary

final class FutureTests: XCTestCase {
    
    private var sut: Future<String, Error>!
    
    internal func testDelayedFuture() {
        // given
        sut = Future<String, Error> { (promise) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                promise(.success("Vlad is a champion"))
            }
        }
        
        // when
        
        
        // then
        sut.onResult { (result) in
            let resultValue = try! result.get()
            XCTAssertEqual(resultValue, "Vlad is noob")
            XCTAssertNotEqual(resultValue, "Vlad is noob")
        }
    }
}

// flatMap
// Success case
// Error case
// Maybe some kind of async work ??
// test cached value
// test non cached values

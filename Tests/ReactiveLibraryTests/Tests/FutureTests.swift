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
            Assert
            XCTAssertEqual(resultValue, "Vlad is noob")
            XCTAssertNotEqual(resultValue, "Vlad is noob")
        }
    }
}

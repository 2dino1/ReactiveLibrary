//
//  SignalTests.swift
//  
//
//  Created by Sima Vlad Grigore on 07/12/2021.
//

import XCTest
@testable import ReactiveLibrary

internal final class SignalTests: XCTestCase {
    private var sut: Signal<String, Error>!
    private var signalHolder: SignalHolderMock!
    
    override func setUp() {
        signalHolder = SignalHolderMock()
        sut = signalHolder.signal()
    }
    
    override func tearDown() {
        sut = nil
        signalHolder = nil
    }
}
 
// MARK: - Sending/Receiving values over time
extension SignalTests {
    internal func testPipeSingleValue() {
        // then
        signalHolder.signal().onResult { result in
            let value = try! result.get()
            XCTAssertEqual(value, "Vlad")
        }
        
        // when
        signalHolder.propertyToChange = "Vlad"
    }
    
    internal func testPipeMultipleValues() {
        // given
        var results: [String] = []
        
        // then
        signalHolder.signal().onResult { result in
            results.append((try? result.get()) ?? "")
            if results.count == 3 {
                XCTAssertEqual(["Vlad", "Dino", "Vladutz"], results)
            }
        }
        
        // when
        signalHolder.propertyToChange = "Vlad"
        signalHolder.propertyToChange = "Dino"
        signalHolder.propertyToChange = "Vladutz"
    }
}

// TODO: Tests for leaks, but cannot leak them here for some reason ?

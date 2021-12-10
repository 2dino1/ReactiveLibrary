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
    private var signalHolderSink: SignalHolderMock!
    private weak var weakSut: Signal<String, Error>!
    
    private var mapSut: Signal<Int?, Error>!
    
    override func setUp() {
        signalHolderSink = SignalHolderMock()
        sut = signalHolderSink.signal()
        weakSut = sut
    }
    
    override func tearDown() {
        sut = nil
        signalHolderSink = nil
        mapSut = nil
    }
}
 
// MARK: - Sending/Receiving values over time
extension SignalTests {
    internal func testPipeSingleValue() {
        // then
        sut.onResult { result in
            let value = try! result.get()
            XCTAssertEqual(value, "Vlad")
        }
        
        // when
        signalHolderSink.propertyToChange = "Vlad"
    }
    
    internal func testPipeMultipleValues() {
        // given
        var results: [String] = []
        
        // then
        sut.onResult { result in
            results.append((try? result.get()) ?? "")
            if results.count == 3 {
                XCTAssertEqual(["Vlad", "Dino", "Vladutz"], results)
            }
        }
        
        // when
        generatePipeInputForMultipleValuesTest()
    }
    
    private func generatePipeInputForMultipleValuesTest() {
        signalHolderSink.propertyToChange = "Vlad"
        signalHolderSink.propertyToChange = "Dino"
        signalHolderSink.propertyToChange = "Vladutz"
    }
    
    internal func testSignalLeaks() {
        // when
        sut = nil
        
        // then
        XCTAssertNil(weakSut)
    }
    
    internal func testSignalMapOperator() {
        // given
        var results: [Int] = []
        
        // then
        mapSut = sut.map { (value) in Int(value) }
        
        mapSut.onResult { (result) in
            results.append((try? result.get()) ?? -1)
            if results.count == 5 {
                XCTAssertEqual(results, [1, 10, -1, -1, 5])
            }
        }
        
        // when
        generatePipeInputForMapOperatorTest()
    }
    
    private func generatePipeInputForMapOperatorTest() {
        signalHolderSink.propertyToChange = "1"
        signalHolderSink.propertyToChange = "10"
        signalHolderSink.propertyToChange = "a"
        signalHolderSink.propertyToChange = "c"
        signalHolderSink.propertyToChange = "5"
    }
}

// TODO: Implement map for signal
// TODO: Implement an AnyCancellable for this signal, implicit subscription and unsubscription

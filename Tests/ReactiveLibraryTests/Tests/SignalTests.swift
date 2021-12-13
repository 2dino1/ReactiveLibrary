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
    private weak var weakSut: Signal<String, Error>!
    private var signalHolderSink: SignalHolderMock!
    private var disposableBag: [Disposable] = []
    
    private var intMapSut: Signal<Int?, Error>!
    private var customObjectMapSut: Signal<Person, Error>!
}

// MARK: - Setup
extension SignalTests {
    override func setUp() {
        setupSut()
        setupWeakSut()
    }
    
    private func setupSut() {
        signalHolderSink = SignalHolderMock()
        sut = signalHolderSink.signal()
    }
    
    private func setupWeakSut() {
        weakSut = sut
    }
}

// MARK: - Tear Down
extension SignalTests {
    override func tearDown() {
        disposeSut()
        // TODO: Removed when the disposable bag will be introduced
        disposeCustomMapSignals()
    }
    
    private func disposeSut() {
        sut = nil
        signalHolderSink = nil
    }
    
    private func disposeCustomMapSignals() {
        intMapSut = nil
        customObjectMapSut = nil
    }
}

// MARK: - Sending/Receiving values over time
extension SignalTests {
    internal func testPipeSingleValue() {
        // given
        let sut: Signal<String, Error> = signalHolderSink.signal()
        
        // then
        let disposable = sut.subscribe { result in
            let value = try! result.get()
            XCTAssertEqual(value, "Vlad")
        }
        
        disposableBag.append(disposable)
        
        // when
        signalHolderSink.stringPropertyToChange = "Vlad"
    }
    
    internal func testPipeMultipleValues() {
        // given
        let sut: Signal<String, Error> = signalHolderSink.signal()
        var results: [String] = []
        
        // then
        let disposable = sut.subscribe { result in
            results.append((try? result.get()) ?? "")
            if results.count == 3 {
                XCTAssertEqual(["Vlad", "Dino", "Vladutz"], results)
            }
        }
        
        disposableBag.append(disposable)
        
        // when
        generatePipeInputForMultipleValuesTest()
    }
    
    private func generatePipeInputForMultipleValuesTest() {
        signalHolderSink.stringPropertyToChange = "Vlad"
        signalHolderSink.stringPropertyToChange = "Dino"
        signalHolderSink.stringPropertyToChange = "Vladutz"
    }
}
 
// MARK: - Leak Tests
extension SignalTests {
    internal func testSignalLeaks() {
        // given
        var sut: Signal<String, Error>? = signalHolderSink.signal()
        weakSut = sut
        
        // when
        sut = nil
        
        // then
        XCTAssertNil(weakSut)
    }
}

// MARK: - Map Operators
extension SignalTests {
    internal func testSignalIntMapOperator() {
        // given
        let sut: Signal<String, Error> = signalHolderSink.signal()
        var results: [Int] = []
        
        // then
        let disposable = sut.map {
            (value) in Int(value)
        }.subscribe { (result) in
            results.append((try? result.get()) ?? -1)
            if results.count == 5 {
                XCTAssertEqual(results, [1, 10, -1, -1, 5])
            }
        }
        
        disposableBag.append(disposable)
        
        // when
        generatePipeInputForIntMapOperatorTest()
    }
    
    private func generatePipeInputForIntMapOperatorTest() {
        signalHolderSink.stringPropertyToChange = "1"
        signalHolderSink.stringPropertyToChange = "10"
        signalHolderSink.stringPropertyToChange = "a"
        signalHolderSink.stringPropertyToChange = "c"
        signalHolderSink.stringPropertyToChange = "5"
    }
    
    internal func testSignalTupleMapOperator() {
        // given
        var results: [Person] = []
        
        // then
        customObjectMapSut = sut.map { (value) in return self.createPerson(from: value) }
        customObjectMapSut.subscribe { (result) in
            results.append((try? result.get()) ?? Person(surname: "", firstName: ""))
            if results.count == 4 {
                XCTAssertEqual(results, self.createCustomObjectMapResults())
                
            }
        }
        
        // when
        generatePipeInputForTupleMapOperatorTest()
    }
    
    private func createPerson(from value: String) -> Person {
        let splittedNames = value.components(separatedBy: .whitespaces)
        return Person(surname: splittedNames[1], firstName: splittedNames[0])
    }
    
    private func generatePipeInputForTupleMapOperatorTest() {
        signalHolderSink.stringPropertyToChange = "Ileana Zaza"
        signalHolderSink.stringPropertyToChange = "Dana Mangea"
        signalHolderSink.stringPropertyToChange = "Vlad Merea"
        signalHolderSink.stringPropertyToChange = "Gligore Romon"
    }
    
    private func createCustomObjectMapResults() -> [Person] {
        return [Person(surname: "Zaza", firstName: "Ileana"),
                Person(surname: "Mangea", firstName: "Dana"),
                Person(surname: "Merea", firstName: "Vlad"),
                Person(surname: "Romon", firstName: "Gligore")]
    }
}

// MARK: - Disposable
extension SignalTests {
    internal func testDisposable() {
        // given
        
        
        // then
        let disposable = sut.subscribe { (result) in }
        disposableBag.append(disposable)
        
        // when
        generatePipeInputForDisposableTest()
    }
    
    private func generatePipeInputForDisposableTest() {
        signalHolderSink.stringPropertyToChange = "Dino"
        signalHolderSink.stringPropertyToChange = "2"
        signalHolderSink.stringPropertyToChange = "Vlad"
    }
}

// TODO: Implement an AnyCancellable for this signal, implicit subscription and unsubscription
// TODO: Implement FlapMap for Signal as well
// TODO: Implement one more operator for Signal :)

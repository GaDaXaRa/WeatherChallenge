//
//  WeatherChallengeIntegrationTests.swift
//  WeatherChallengeIntegrationTests
//
//  Created by Miguel Santiago Rodríguez on 9/12/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import XCTest

@testable import WeatherChallenge

class WeatherChallengeIntegrationTests: XCTestCase {
    
    class MockedDelegate: WeatherManagerDelegate {
        let delegateExpectation: XCTestExpectation
        
        var weather: Weather?
        
        init(delegateExpectation: XCTestExpectation) {
            self.delegateExpectation = delegateExpectation
        }
        
        func didUpdateWeather(_ weather: Weather) {
            self.weather = weather
            delegateExpectation.fulfill()
        }
        
        func didSaveWeather(_ weather: Weather) {
            
        }
    }
    
    func testShouldAskFroWeather() {
        let sut = WeatherManager()
        let delegate = MockedDelegate(delegateExpectation: expectation(description: "fetch weather expectataion"))
        let saveExpectation = expectation(description: "save weather expectation")
        sut.delegate = delegate
        sut.weather(at: "London")
        
        waitForExpectations(timeout: 5) { (error) in
            if error != nil { XCTFail() }
            XCTAssertEqual("London", delegate.weather!.city)
        }
    }
    
}

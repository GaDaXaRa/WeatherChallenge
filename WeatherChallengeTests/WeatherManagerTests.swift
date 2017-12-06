//
//  WeatherManagerTests.swift
//  WeatherChallengeTests
//
//  Created by Miguel Santiago Rodríguez on 1/12/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import XCTest

@testable import WeatherChallenge

class WeatherManagerTests: XCTestCase {
    
    class MockedDelegate: WeatherManagerDelegate {
        var weather: Weather?
        let expectation: XCTestExpectation?
        
        init(expectation: XCTestExpectation?) {
            self.expectation = expectation
        }
        
        func didUpdateWeather(_ weather: Weather) {
            self.weather = weather
            expectation?.fulfill()
        }
    }
    
    class MockedUseCase: FetchWeatherUseCase {
        func fetchWeather(at city: String, _ completion: @escaping (Weather?) -> ()) {
            completion(Weather(json: Mocks.weatherJSON(at: city)))
        }
    }
    
    let sut = WeatherManager(fetchWeather: MockedUseCase())
    
    func testShouldReturnWeatherByCity() {
        let delegate = MockedDelegate(expectation: expectation(description: "delegate expectation"))
        sut.delegate = delegate
        
        sut.weather(at: "London")
        
        waitForExpectations(timeout: 0.5) { (error) in
            if error != nil { XCTFail() }
            XCTAssertEqual("London", delegate.weather?.city)
        }
    }    
}

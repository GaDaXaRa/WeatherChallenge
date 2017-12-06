//
//  FetchWeatherTests.swift
//  WeatherChallengeTests
//
//  Created by Miguel Santiago Rodríguez on 29/11/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import XCTest

@testable import WeatherChallenge

class FetchWeatherTests: XCTestCase {
    
    struct MockedTask: FetchWeatherTask {
        func fetch(by coordinates: (lat: String, lon: String), _ completion: @escaping ([String : Any]?) -> ()) {
            completion(Mocks.weatherJSON)
        }
        
        func fetch(by city: String, _ completion: @escaping ([String : Any]?) -> ()) {
            completion(Mocks.weatherJSON)
        }        
    }
    
    func testShouldFetchWeatherFromACity() {
        let sut = FetchWeather(task: MockedTask())
        let sutExpectation = expectation(description: "fetch weather")
        sut.fetchWeather(at: "London") { weather in
            XCTAssertNotNil(weather)
            sutExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5) { (error) in
            if error != nil {XCTFail()}
        }
    }
    
}
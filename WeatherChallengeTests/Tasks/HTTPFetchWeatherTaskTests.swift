//
//  HTTPFetchWeatherTaskTests.swift
//  WeatherChallengeTests
//
//  Created by Miguel Santiago Rodríguez on 29/11/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import XCTest

@testable import WeatherChallenge

class HTTPFetchWeatherTaskTests: XCTestCase {
    
    func testShouldFetchByCity() {
        let sut = HTTPFetchWeatherTask(city: "London") { (json) in
            
        }
        
        let queryItems = URLComponents(url: sut.request!.url!, resolvingAgainstBaseURL: false)?.queryItems
        XCTAssertNotNil(queryItems?.filter{$0.name == "q" && $0.value == "London"})
    }
    
    func testShouldSendAPPID() {
        let testURL = URL(string: "www.test.com")!
        let configuration = HTTPFetchWeatherTask.Configuration.init(session: URLSession.shared, baseUrl: testURL, appId: "1234")
        let sut = HTTPFetchWeatherTask(configuration: configuration, city: "London") { (json) in
            
        }
        
        let queryItems = URLComponents(url: sut.request!.url!, resolvingAgainstBaseURL: false)?.queryItems
        XCTAssertNotNil(queryItems?.filter{$0.name == "APPID" && $0.value == "1234"})
    }
    
}

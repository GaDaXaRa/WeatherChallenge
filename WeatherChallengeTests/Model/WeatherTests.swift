//
//  WeatherTests.swift
//  WeatherChallengeTests
//
//  Created by Miguel Santiago Rodríguez on 29/11/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import XCTest

@testable import WeatherChallenge

class WeatherTests: XCTestCase {
    
    static let json = Mocks.weatherJSON
    static let imageUrlPrefix = "images/"
    
    let date = Date()
    
    func testShouldParseWeather() {
        let sut = Weather(json: WeatherTests.json, creationDate: date, imageUrlPrefix: WeatherTests.imageUrlPrefix)!
        XCTAssertEqual("Clouds", sut.name)
        XCTAssertEqual("broken clouds", sut.description)
        XCTAssertEqual("London", sut.city)
        XCTAssertEqual(277.15, sut.minTemp)
        XCTAssertEqual(279.15, sut.maxTemp)
        XCTAssertEqual(URL(string:"\(WeatherTests.imageUrlPrefix)04n")!, sut.iconURL)
        XCTAssertEqual(date, sut.creationDate)
        XCTAssertEqual(-0.13, sut.location.longitude)
        XCTAssertEqual(51.51, sut.location.latitude)
    }
}

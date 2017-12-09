//
//  WeatherTests.swift
//  WeatherChallengeTests
//
//  Created by Miguel Santiago Rodríguez on 29/11/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import XCTest

@testable import WeatherChallenge

extension Mocks {
    static var weatherJSON: [String: Any] {
        return try! JSONSerialization.jsonObject(with: Mocks.weatherString.data(using: .utf8)!, options: []) as! [String: Any]
    }
    
    static var weatherString: String {
        return """
        {"coord":{"lon":-0.13,"lat":51.51},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],"base":"stations","main":{"temp":277.87,"pressure":1011,"humidity":75,"temp_min":277.15,"temp_max":279.15},"visibility":10000,"wind":{"speed":4.1,"deg":320},"clouds":{"all":75},"dt":1511976000,"sys":{"type":1,"id":5091,"message":0.0035,"country":"GB","sunrise":1511941334,"sunset":1511970943},"id":2643743,"name":"London","cod":200}
        """
    }
}

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
        XCTAssertEqual(URL(string:"\(WeatherTests.imageUrlPrefix)04n.png")!, sut.iconURL)
        XCTAssertEqual(date, sut.creationDate)
        XCTAssertEqual(-0.13, sut.location.longitude)
        XCTAssertEqual(51.51, sut.location.latitude)
    }
}

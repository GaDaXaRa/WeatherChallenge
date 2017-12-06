//
//  FetchWeatherTests.swift
//  WeatherChallengeTests
//
//  Created by Miguel Santiago Rodríguez on 29/11/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import XCTest
import CoreLocation

@testable import WeatherChallenge

class FetchWeatherTests: XCTestCase {
    
    struct MockedTask: FetchWeatherTask {
        func fetch(by coordinates: (lat: String, lon: String), _ completion: @escaping ([String : Any]?) -> ()) {
            let stringCoordinates = (lat: Double(coordinates.lat)!, lon: Double(coordinates.lon)!)
            completion(Mocks.weatherJSON(coordinates: stringCoordinates))
        }
        
        func fetch(by city: String, _ completion: @escaping ([String : Any]?) -> ()) {
            completion(Mocks.weatherJSON(at: city))
        }        
    }
    
    class MockedLocationPersmissionsChecker: CheckLocationPermission {
        override func isGranted() -> Bool {
            return true
        }
    }
    
    
    let sut = FetchWeather(task: MockedTask(), checkLocationPermission: MockedLocationPersmissionsChecker())
    
    func testShouldFetchWeatherFromACity() {
        let sutExpectation = expectation(description: "fetch by city")
        sut.fetchWeather(at: "London") { weather in
            XCTAssertEqual("London", weather?.city)
            sutExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5) { (error) in
            if error != nil {XCTFail()}
        }
    }
    
    func testShouldFetchWeatherByCoordinates() {
        let sutExpectation = expectation(description: "fetch by coordinates")
        sut.fetchWeather(at: (lat: 545.33, lon: -33.5)) { weather in
            XCTAssertEqual(545.33, weather?.location.latitude)
            XCTAssertEqual(-33.5, weather?.location.longitude)
            sutExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5) { (error) in
            if error != nil {XCTFail()}
        }
    }
    
    func testShouldFetchWeatherAtUserLocation() {
        let sutExpectation = expectation(description: "fetch by user location")
        let mockedLocationManager = Mocks.MockedLocationManager()
        let mockedLocation = CLLocation(latitude: 112.0, longitude: -343.22)
        mockedLocationManager.mockedLocation = mockedLocation
        sut.fetchWeatherAtCurrentLocation(with: mockedLocationManager) { (weather) in
            XCTAssertEqual(mockedLocation.coordinate.latitude, weather?.location.latitude)
            XCTAssertEqual(mockedLocation.coordinate.longitude, weather?.location.longitude)
            sutExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5) { (error) in
            if error != nil {XCTFail()}
        }
    }
}

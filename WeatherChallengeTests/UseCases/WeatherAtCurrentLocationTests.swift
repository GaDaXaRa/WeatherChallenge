//
//  WeatherAtCurrentLocationTests.swift
//  WeatherChallengeTests
//
//  Created by Miguel Santiago Rodríguez on 6/12/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import XCTest
import CoreLocation

@testable import WeatherChallenge

class WeatherAtCurrentLocationTests: XCTestCase {
    
    class MockedLocationPersmissionsChecker: CheckLocationPermission {
        override func isGranted() -> Bool {
            return true
        }
    }
    
    class MockedFetchWeatherUseCase: FetchWeatherUseCase {
        func fetchWeather(at city: String, _ completion: @escaping (Weather?) -> ()) {
            completion(nil)
        }
        
        func fetchWeather(at coordinates: (lat: Double, lon: Double), _ completion: @escaping (Weather?) -> ()) {
            completion(Weather(json: Mocks.weatherJSON(coordinates: coordinates)))
        }
    }
    
    func testShouldFetchWeatherAtUserLocation() {
        let sutExpectation = expectation(description: "fetch by user location")
        let mockedLocationManager = Mocks.MockedLocationManager()
        let mockedLocation = CLLocation(latitude: 112.0, longitude: -343.22)
        mockedLocationManager.mockedLocation = mockedLocation
        let sut = WeatherAtCurrentLocation(fetchWeather: MockedFetchWeatherUseCase(), checkLocationPermission: MockedLocationPersmissionsChecker())
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

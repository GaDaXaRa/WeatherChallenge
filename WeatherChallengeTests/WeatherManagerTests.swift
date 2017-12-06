//
//  WeatherManagerTests.swift
//  WeatherChallengeTests
//
//  Created by Miguel Santiago Rodríguez on 1/12/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import XCTest
import CoreLocation

@testable import WeatherChallenge

class WeatherManagerTests: XCTestCase {
    
    let sut = WeatherManager(fetchWeather: MockedUseCase(), weatherAtCurrenLocation: MockedWeatherAtCurrentLocationUseCase(), weatherStorage: MockedWeatherStorage())
    
    func testShouldReturnWeatherByCity() {
        let delegate = MockedDelegate(expectation: expectation(description: "weather by city expectation"))
        sut.delegate = delegate
        
        sut.weather(at: "London")
        
        waitForExpectations(timeout: 0.5) { (error) in
            if error != nil { XCTFail() }
            XCTAssertEqual("London", delegate.weather?.city)
        }
    }
    
    func testShouldReturnWeatherByCoordinates() {
        let delegate = MockedDelegate(expectation: expectation(description: "weather by coordinates expectation"))
        sut.delegate = delegate
        
        sut.weather(at: (lat: 112.0, lon:-343.22))
        
        waitForExpectations(timeout: 0.5) { (error) in
            if error != nil { XCTFail() }
            XCTAssertEqual(112.0, delegate.weather?.location.latitude)
            XCTAssertEqual(-343.22, delegate.weather?.location.longitude)
        }
    }
    
    func testShouldReturnWeatherByUserLocation() {
        let mockedLocationManager = Mocks.MockedLocationManager()
        let mockedLocation = CLLocation(latitude: 112.0, longitude: -343.22)
        mockedLocationManager.mockedLocation = mockedLocation
        let delegate = MockedDelegate(expectation: expectation(description: "weather by coordinates expectation"))
        sut.delegate = delegate
        
        sut.weatherAtCurrentLocation(locationManager: mockedLocationManager)
        
        waitForExpectations(timeout: 0.5) { (error) in
            if error != nil { XCTFail() }
            XCTAssertEqual(mockedLocation.coordinate.latitude, delegate.weather?.location.latitude)
            XCTAssertEqual(mockedLocation.coordinate.longitude, delegate.weather?.location.longitude)
        }
    }
    
    func testShouldQuerySavedItems() {
        let weather = Weather(json: Mocks.weatherJSON())!
        let sutExpectation = expectation(description: "query saved items")
        sut.save(weather: weather)
        sut.listSaved { (weathers) in
            XCTAssertEqual(weather, weathers.first!)
            sutExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5) { (error) in
            if error != nil { XCTFail() }
        }
    }
}

extension WeatherManagerTests {
        
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
        func fetchWeather(at coordinates: (lat: Double, lon: Double), _ completion: @escaping (Weather?) -> ()) {
            completion(Weather(json: Mocks.weatherJSON(coordinates: coordinates)))
        }
        
        func fetchWeather(at city: String, _ completion: @escaping (Weather?) -> ()) {
            completion(Weather(json: Mocks.weatherJSON(at: city)))
        }
    }
    
    class MockedWeatherAtCurrentLocationUseCase: WeatherAtCurrentLocationUseCase {
        func fetchWeatherAtCurrentLocation(with locationManager: CLLocationManager, _ completion: @escaping (Weather?) -> ()) {
            let coordinates = (lat: locationManager.location!.coordinate.latitude, lon: locationManager.location!.coordinate.longitude)
            completion(Weather(json: Mocks.weatherJSON(coordinates: coordinates)))
        }
    }
    
    class MockedWeatherStorage: WeatherStorage {
        var weathers = [Weather]()
        
        func save(_ weather: Weather) {
            weathers.append(weather)
        }
        
        func listAll(_ completion: @escaping ([Weather]) -> ()) {
            completion(weathers)
        }
    }
}

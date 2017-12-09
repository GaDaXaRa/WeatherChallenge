//
//  WeatherManager.swift
//  WeatherChallenge
//
//  Created by Miguel Santiago Rodríguez on 1/12/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import CoreLocation

protocol FetchWeatherUseCase {
    func fetchWeather(at city: String, _ completion: @escaping (Weather?) -> ())
    func fetchWeather(at coordinates: (lat: Double, lon: Double), _ completion: @escaping (Weather?) -> ())
}

protocol WeatherAtCurrentLocationUseCase {
    func fetchWeatherAtCurrentLocation(with locationManager: CLLocationManager, _ completion: @escaping (Weather?) -> ())
}

public protocol WeatherManagerDelegate: class {
    func didUpdateWeather(_ weather: Weather)
    func didSaveWeather(_ weather: Weather)
}

protocol WeatherStorage {
    func save(_ weather: Weather)
    func listAll(_: @escaping ([Weather]) -> ())
}

open class WeatherManager: NSObject {
    private(set) var weather: Weather? {
        didSet {
            guard let weather = weather else { return }
            delegate?.didUpdateWeather(weather)
        }
    }
    
    private let fetchWeather: FetchWeatherUseCase
    private let weatherAtCurrenLocation: WeatherAtCurrentLocationUseCase
    private let weatherStorage: WeatherStorage
    
    open weak var delegate: WeatherManagerDelegate?
    
    public override init() {
        self.fetchWeather = FetchWeather()
        self.weatherAtCurrenLocation = WeatherAtCurrentLocation()
        self.weatherStorage = CodableDiskStorage<Weather>()
    }
    
    init(fetchWeather: FetchWeatherUseCase = FetchWeather(), weatherAtCurrenLocation: WeatherAtCurrentLocationUseCase = WeatherAtCurrentLocation(), weatherStorage: WeatherStorage = CodableDiskStorage<Weather>()) {
        self.fetchWeather = fetchWeather
        self.weatherAtCurrenLocation = weatherAtCurrenLocation
        self.weatherStorage = weatherStorage
    }

    open func weather(at city: String) {
        fetchWeather.fetchWeather(at: city) { (weather) in
            self.weather = weather
        }
    }
    
    open func weather(at coordinates: (lat: Double, lon: Double)) {
        fetchWeather.fetchWeather(at: coordinates) { (weather) in
            self.weather = weather
        }
    }
    
    open func weatherAtCurrentLocation(locationManager: CLLocationManager) {
        weatherAtCurrenLocation.fetchWeatherAtCurrentLocation(with: locationManager) { (weather) in
            self.weather = weather
        }
    }
    
    open func save(weather: Weather) {
        weatherStorage.save(weather)
        delegate?.didSaveWeather(weather)
    }
    
    open func listSaved(_ completion: @escaping ([Weather]) -> ()) {
        weatherStorage.listAll(completion)
    }
}

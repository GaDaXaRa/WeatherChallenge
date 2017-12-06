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

protocol WeatherManagerDelegate: class {
    func didUpdateWeather(_ weather: Weather)
    func didSaveWeather(_ weather: Weather)
}

protocol WeatherStorage {
    func save(_ weather: Weather)
    func listAll(_: @escaping ([Weather]) -> ())
}

class WeatherManager: NSObject {
    private(set) var weather: Weather? {
        didSet {
            guard let weather = weather else { return }
            delegate?.didUpdateWeather(weather)
        }
    }
    
    let fetchWeather: FetchWeatherUseCase
    let weatherAtCurrenLocation: WeatherAtCurrentLocationUseCase
    let weatherStorage: WeatherStorage
    
    weak var delegate: WeatherManagerDelegate?    
    
    init(fetchWeather: FetchWeatherUseCase = FetchWeather(), weatherAtCurrenLocation: WeatherAtCurrentLocationUseCase = WeatherAtCurrentLocation(), weatherStorage: WeatherStorage = CodableDiskStorage<Weather>()) {
        self.fetchWeather = fetchWeather
        self.weatherAtCurrenLocation = weatherAtCurrenLocation
        self.weatherStorage = weatherStorage
    }

    func weather(at city: String) {
        fetchWeather.fetchWeather(at: city) { (weather) in
            self.weather = weather
        }
    }
    
    func weather(at coordinates: (lat: Double, lon: Double)) {
        fetchWeather.fetchWeather(at: coordinates) { (weather) in
            self.weather = weather
        }
    }
    
    func weatherAtCurrentLocation(locationManager: CLLocationManager) {
        weatherAtCurrenLocation.fetchWeatherAtCurrentLocation(with: locationManager) { (weather) in
            self.weather = weather
        }
    }
    
    func save(weather: Weather) {
        weatherStorage.save(weather)
        delegate?.didSaveWeather(weather)
    }
    
    func listSaved(_ completion: @escaping ([Weather]) -> ()) {
        weatherStorage.listAll(completion)
    }
}

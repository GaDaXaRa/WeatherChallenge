//
//  WeatherManager.swift
//  WeatherChallenge
//
//  Created by Miguel Santiago Rodríguez on 1/12/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import UIKit

protocol FetchWeatherUseCase {
    func fetchWeather(at city: String, _ completion: @escaping (Weather?) -> ())
}

protocol WeatherManagerDelegate: class {
    func didUpdateWeather(_ weather: Weather)
}

class WeatherManager: NSObject {
    let fetchWeather: FetchWeatherUseCase
    weak var delegate: WeatherManagerDelegate?
    
    init(fetchWeather: FetchWeatherUseCase = FetchWeather(task: HTTPFetchWeatherTask())) {
        self.fetchWeather = fetchWeather
    }

    func weather(at city: String) {
        fetchWeather.fetchWeather(at: city) { (weather) in
            guard let weather = weather else { return }
            self.delegate?.didUpdateWeather(weather)
        }
    }
}

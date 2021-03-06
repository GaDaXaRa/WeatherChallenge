//
//  FetchWeather.swift
//  WeatherChallenge
//
//  Created by Miguel Santiago Rodríguez on 29/11/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import CoreLocation

protocol FetchWeatherTask {
    func fetch(by city: String, _ completion: @escaping ([String : Any]?) -> ())
    func fetch(by coordinates:(lat: String, lon: String), _ completion: @escaping ([String : Any]?) -> ())
}

class FetchWeather: NSObject {
    
    let task: FetchWeatherTask
    
    init(task: FetchWeatherTask = HTTPFetchWeatherTask()) {
        self.task = task
    }
}

extension FetchWeather: FetchWeatherUseCase {
    
    func fetchWeather(at coordinates: (lat: Double, lon: Double), _ completion: @escaping (Weather?) -> ()) {
        DispatchQueue.global().async {
            let coordinates = (lat: "\(coordinates.lat)", lon: "\(coordinates.lon)")
            self.task.fetch(by: coordinates, { (json) in
                completion(Weather(json: json))
            })
        }
    }
    
    func fetchWeather(at city: String, _ completion: @escaping (Weather?) -> ()) {
        DispatchQueue.global().async {
            self.task.fetch(by: city, { (json) in
                completion(Weather(json: json))
            })
        }
    }
}


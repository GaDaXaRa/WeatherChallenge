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
    
    var userLocationCompletion: ((Weather?) -> ())?
    let task: FetchWeatherTask
    let checkLocationPermission: CheckLocationPermission
    
    init(task: FetchWeatherTask, checkLocationPermission: CheckLocationPermission = CheckLocationPermission()) {
        self.task = task
        self.checkLocationPermission = checkLocationPermission
    }
}

extension FetchWeather: FetchWeatherUseCase {
    func fetchWeatherAtCurrentLocation(with locationManager: CLLocationManager, _ completion: @escaping (Weather?) -> ()) {
        guard checkLocationPermission.isGranted() else {
            completion(nil)
            return
        }
        userLocationCompletion = completion
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
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

extension FetchWeather: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first, let completion = userLocationCompletion else { return }
        manager.stopUpdatingLocation()
        let coordinates = (lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        fetchWeather(at: coordinates, completion)
        userLocationCompletion = nil
    }
}

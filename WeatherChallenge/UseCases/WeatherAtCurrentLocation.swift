//
//  WeatherAtCurrentLocation.swift
//  WeatherChallenge
//
//  Created by Miguel Santiago Rodríguez on 6/12/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import CoreLocation

class WeatherAtCurrentLocation: NSObject {
    let fetchWeather: FetchWeatherUseCase
    let checkLocationPermission: CheckLocationPermission
    
    var userLocationCompletion: ((Weather?) -> ())?
    
    init(fetchWeather: FetchWeatherUseCase = FetchWeather(), checkLocationPermission: CheckLocationPermission = CheckLocationPermission()) {
        self.fetchWeather = fetchWeather
        self.checkLocationPermission = checkLocationPermission
    }
}

extension WeatherAtCurrentLocation: WeatherAtCurrentLocationUseCase {
    func fetchWeatherAtCurrentLocation(with locationManager: CLLocationManager, _ completion: @escaping (Weather?) -> ()) {
        guard checkLocationPermission.isGranted() else {
            completion(nil)
            return
        }
        userLocationCompletion = completion
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
}

extension WeatherAtCurrentLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first, let completion = userLocationCompletion else { return }
        manager.stopUpdatingLocation()
        let coordinates = (lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        fetchWeather.fetchWeather(at: coordinates, completion)
        userLocationCompletion = nil
    }
}

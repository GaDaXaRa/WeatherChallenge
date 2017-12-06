//
//  CheckLocationPermission.swift
//  WeatherChallenge
//
//  Created by Miguel Santiago Rodríguez on 6/12/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import CoreLocation

class CheckLocationPermission: NSObject {

    func isGranted() -> Bool {
        return CLLocationManager.locationServicesEnabled() && [.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus())
    }
}

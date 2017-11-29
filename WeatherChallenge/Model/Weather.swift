//
//  File.swift
//  WeatherChallenge
//
//  Created by Miguel Santiago Rodríguez on 29/11/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import Foundation

struct Weather {
    let name: String
    let minTemp: Float
    let maxTemp: Float
    let iconURL: URL?
    let creationDate: Date
    
    let imageUrlPrefix: String
    
    init?(json: [String: Any]?, creationDate: Date = Date(), imageUrlPrefix: String = "http://openweathermap.org/img/w/") {
        guard
            let json = json,
            let name = json["name"] as? String,
            let main = json["main"] as? [String: Any],
            let minTemp = main["temp_min"] as? Float,
            let maxTemp = main["temp_max"] as? Float,
            let weather = json["weather"] as? [[String: Any]],
            let icon = weather.first?["icon"] as? String
            else {
                return nil
        }
        
        self.name = name
        self.creationDate = creationDate
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.iconURL = URL(string: "\(imageUrlPrefix)\(icon)")
        
        self.imageUrlPrefix = imageUrlPrefix
    }
}

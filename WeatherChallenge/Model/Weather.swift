//
//  File.swift
//  WeatherChallenge
//
//  Created by Miguel Santiago Rodríguez on 29/11/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import Foundation

public struct Weather: Codable {
    public struct Location: Codable {
        let latitude: Double
        let longitude: Double
    }
    
    public let name: String
    public let description: String
    public let city: String
    public let minTemp: Float
    public let maxTemp: Float
    public let iconURL: URL?
    public let creationDate: Date
    public let location: Location
    
    let imageUrlPrefix: String
    
    init?(json: [String: Any]?, creationDate: Date = Date(), imageUrlPrefix: String = "https://openweathermap.org/img/w/") {
        guard
            let json = json,
            let city = json["name"] as? String,
            let main = json["main"] as? [String: Any],
            let minTemp = main["temp_min"] as? Float,
            let maxTemp = main["temp_max"] as? Float,
            let weathers = json["weather"] as? [[String: Any]], let weather = weathers.first,
            let icon = weather["icon"] as? String,
            let name = weather["main"] as? String,
            let description = weather["description"] as? String,
            let location = json["coord"] as? [String: Any],
            let latitude = location["lat"] as? Double,
            let longitude = location["lon"] as? Double
            else {
                return nil
        }
        
        self.name = name
        self.description = description
        self.city = city
        self.creationDate = creationDate
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.iconURL = URL(string: "\(imageUrlPrefix)\(icon).png")
        self.location = Location(latitude: latitude, longitude: longitude)
        
        self.imageUrlPrefix = imageUrlPrefix
    }
}

extension Weather.Location: Equatable {
    public static func ==(lhs: Weather.Location, rhs: Weather.Location) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension Weather: Equatable {
    public static func ==(lhs: Weather, rhs: Weather) -> Bool {
        return lhs.name == rhs.name && lhs.description == rhs.description && lhs.city == rhs.city && lhs.creationDate == rhs.creationDate && lhs.minTemp == rhs.minTemp && lhs.maxTemp == rhs.maxTemp && lhs.iconURL == rhs.iconURL && lhs.location == rhs.location
    }
    
    
}

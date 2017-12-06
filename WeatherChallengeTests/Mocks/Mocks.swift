//
//  File.swift
//  WeatherChallengeTests
//
//  Created by Miguel Santiago Rodríguez on 29/11/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import Foundation

struct Mocks {
    
    
    static func weatherJSON(at city: String) -> [String: Any] {
        return try! JSONSerialization.jsonObject(with: weather(at: city).data(using: .utf8)!, options: []) as! [String: Any]
    }
    
    static func weather(at city: String) -> String {
        return """
        {"coord":{"lon":-0.13,"lat":51.51},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],"base":"stations","main":{"temp":277.87,"pressure":1011,"humidity":75,"temp_min":277.15,"temp_max":279.15},"visibility":10000,"wind":{"speed":4.1,"deg":320},"clouds":{"all":75},"dt":1511976000,"sys":{"type":1,"id":5091,"message":0.0035,"country":"GB","sunrise":1511941334,"sunset":1511970943},"id":2643743,"name":"\(city)","cod":200}
        """
    }
}

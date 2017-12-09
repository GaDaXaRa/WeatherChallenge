//
//  HTTPFetchWeatherTask.swift
//  WeatherChallenge
//
//  Created by Miguel Santiago Rodríguez on 29/11/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import UIKit

class HTTPFetchWeatherTask: NSObject {
    
    private(set) var payload = [String: String]()
    
    fileprivate let configuration: Configuration
    
    init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
        payload["APPID"] = configuration.appId
    }
    
}

extension HTTPFetchWeatherTask: FetchWeatherTask {
    func fetch(by coordinates: (lat: String, lon: String), _ completion: @escaping ([String : Any]?) -> ()) {
        payload["lat"] = coordinates.lat
        payload["lon"] = coordinates.lon
        buildTask(completion)
    }
    
    func fetch(by city: String, _ completion: @escaping ([String : Any]?) -> ()) {
        payload["q"] = city
        buildTask(completion)
    }
}

extension HTTPFetchWeatherTask {
    private func buildTask(_ completion: @escaping ([String:Any]?) -> ()) {
        guard let url = compose(url: configuration.baseUrl, with: payload)  else { return }
        
        configuration.session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard
                error == nil,
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            else {
                completion(nil)
                return
            }
            completion(json)
        }.resume()
    }
    
    private func compose(url: URL, with params: [String: String]) -> URL? {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = params.map {URLQueryItem(name: $0.key, value: $0.value)}
        return components?.url
    }
}

extension HTTPFetchWeatherTask {
    class Configuration {
        let session: URLSession
        let appId: String
        let baseUrl: URL
        
        init(session: URLSession = URLSession.shared, baseUrl: URL = URL(string: "https://api.openweathermap.org/data/2.5/weather")!, appId: String = "b83c13b2ab60f7ec52b12d6fcf3f9f42") {
            self.session = session
            self.appId = appId
            self.baseUrl = baseUrl
        }
    }
}

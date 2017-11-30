//
//  HTTPFetchWeatherTask.swift
//  WeatherChallenge
//
//  Created by Miguel Santiago Rodríguez on 29/11/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import UIKit

class HTTPFetchWeatherTask: NSObject {
    
    fileprivate let dataTask: URLSessionDataTask?
    var request: URLRequest? {
        return dataTask?.currentRequest
    }
    private var payload = [String: String]()
    
    init(configuration: Configuration = Configuration(), city: String, _ completion: @escaping ([String:Any]?) -> ()) {
        payload["APPID"] = configuration.appId
        payload["q"] = city
        self.dataTask = HTTPFetchWeatherTask.buildTask(for: configuration.baseUrl, with: payload, in: configuration.session, completion)
    }    
    
    func resume() {
        dataTask?.resume()
    }
}

extension HTTPFetchWeatherTask {
    static func buildTask(for url: URL, with params:[String: String], in session: URLSession, _ completion: @escaping ([String:Any]?) -> ()) -> URLSessionDataTask? {
        guard let url = compose(url: url, with: params)  else { return nil }
        
        return session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard error != nil, let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                completion(nil)
                return
            }
            completion(json)
        }
    }
    
    private static func compose(url: URL, with params: [String: String]) -> URL? {
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
        
        init(session: URLSession = URLSession.shared, baseUrl: URL = URL(string: "api.openweathermap.org/data/2.5/weather")!, appId: String = "b83c13b2ab60f7ec52b12d6fcf3f9f42") {
            self.session = session
            self.appId = appId
            self.baseUrl = baseUrl
        }
    }
}

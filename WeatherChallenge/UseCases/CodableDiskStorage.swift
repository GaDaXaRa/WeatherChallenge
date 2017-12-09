//
//  WeatherCodableJSONStorage.swift
//  WeatherChallenge
//
//  Created by Miguel Santiago Rodríguez on 6/12/17.
//  Copyright © 2017 Miguel Santiago Rodríguez. All rights reserved.
//

import UIKit

class CodableDiskStorage<T: Codable>: NSObject {
    
    struct DatabaseModel: Codable {
        var elements: [T]
    }

    let fileManager: FileManager
    let fileName: String
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    
    private var storageLocation: URL {
        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {fatalError("could not open documents folder")}
        return documentsUrl.appendingPathComponent(fileName)
    }
    
    init(fileManager: FileManager = FileManager.default, fileName: String = "codableDiskStorage.json", encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) {
        self.fileManager = fileManager
        self.fileName = fileName
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func persist(_ item: T) {
        var currentElements = fetchAll()
        currentElements.append(item)
        try? encoder.encode(currentElements).write(to: storageLocation)
    }
    
    func fetchAll() -> [T] {
        guard let items = try? decoder.decode([T].self, from: Data(contentsOf: storageLocation)) else {
            return [T]()
        }
        
        return items
    }
}

extension CodableDiskStorage: WeatherStorage {
    func save(_ weather: Weather) {
        guard let weather = weather as? T else { return }
        persist(weather)
    }
    
    func listAll(_ completion: @escaping ([Weather]) -> ()) {
        guard let allItems = fetchAll() as? [Weather] else {
            completion([Weather]())
            return
        }
        completion(allItems)
    }
}

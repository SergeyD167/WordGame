//
//  StorageManager.swift
//  WordGame
//
//  Created by Сергей Дятлов on 24.09.2024.
//

import Foundation

protocol StorageManagerProtocol {
    func save<T: Codable>(_ object: T, forKey key: String)
    func load<T: Codable>(forKey key: String) -> T?
    func delete(forKey key: String)
}

final class StorageManager: StorageManagerProtocol {
    
    func save<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(object) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }

    func load<T: Codable>(forKey key: String) -> T? {
        guard let savedData = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: savedData)
    }

    func delete(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

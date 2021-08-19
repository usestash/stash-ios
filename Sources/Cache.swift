//
//  Storage.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 02.07.2021.
//

import Foundation

/// Class handling the caching of events.
class Cache<T: Codable> {
    /// Underlying cache.
    private let cache = NSCache<NSString, AnyObject>()
    /// Cached keys.
    private var keys = [String]()
    
    /// Saves an event.
    /// - Parameters:
    ///   - object: The event object to save.
    ///   - encoder: The encoder to be used.
    func save(object: T, encoder: JSONEncoder = JSONEncoder()) {
        let key =  NSUUID.init().uuidString
        guard let data = try? encoder.encode(object) else {
            return
        }
        cache.setObject(data as AnyObject, forKey: key as NSString)
        keys.append(key)
    }
    
    /// Retrieves all the events stored.
    /// - Parameter decorder: The JSON encoder to be used.
    /// - Returns: An  array of events.
    func getAll(decorder: JSONDecoder = JSONDecoder()) -> [T] {
        return keys.compactMap { key in
            guard let data = cache.object(forKey: key as NSString) as? Data else {
                return nil
            }
            return try? decorder.decode(T.self, from: data)
        }
    }
    
    /// Removes all the cached events.
    func removeAll() {
        cache.removeAllObjects()
        keys.removeAll()
    }
}

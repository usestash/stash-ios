//
//  Storage.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 02.07.2021.
//

import Foundation

class Cache<T: Codable> {
    private let cache = NSCache<NSString, AnyObject>()
    private var keys = [String]()
    private let encoder = JSONEncoder()

    func save(object: T, encoder: JSONEncoder = JSONEncoder()) {
        let key =  NSUUID.init().uuidString
        guard let data = try? encoder.encode(object) else {
            return
        }
        cache.setObject(data as AnyObject, forKey: key as NSString)
        keys.append(key)
    }

    func getAll(decorder: JSONDecoder = JSONDecoder()) -> [T] {
        return keys.compactMap { key in
            guard let data = cache.object(forKey: key as NSString) as? Data else {
                return nil
            }
            return try? decorder.decode(T.self, from: data)
        }
    }
    
    func removeAll() {
        cache.removeAllObjects()
        keys.removeAll()
    }
}

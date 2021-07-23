//
//  Persistence.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 23.07.2021.
//

import Foundation

struct PersistedProperties: Codable {
    var appVersion: String?
    var appRelease: String?
    var osVersion: String?
}

class Persistence {    
    var properties: PersistedProperties!
    let token: String
    
    init(token: String) {
        self.token = token
        if let previouslySavedProperties = loadPropertiesFromFile() {
            self.properties = previouslySavedProperties
        } else {
            self.properties = PersistedProperties(appVersion: Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
                                                  appRelease: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                                                  osVersion: UIDevice.current.systemVersion)
        }
    }
    
    public func save() {
        savePropertiesToFile(properties: properties)
    }
    
    private func savePropertiesToFile(properties: PersistedProperties) {
        guard let path = filePath(with: token) else {
            print("Invalid path")
            return
        }
        
        do {
            let objectData = try PropertyListEncoder().encode(properties)
            let data = try NSKeyedArchiver.archivedData(withRootObject: objectData, requiringSecureCoding: false)
            let fileUrl = URL(fileURLWithPath: path)
            try data.write(to: fileUrl)
        } catch {
            print("Save to file failed: \(error)")
        }
    }
    
    private func loadPropertiesFromFile() -> PersistedProperties? {
        guard let path = filePath(with: token) else {
            print("Invalid path")
            return nil
        }
        
        let fileUrl = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: fileUrl),
              let unarchivedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data,
              let properties = try? PropertyListDecoder().decode(PersistedProperties.self, from: unarchivedData) else {
            print("Loading from file failed")
            return nil
        }
        
        return properties
    }
    
    private func filePath(with token: String) -> String? {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).last
        let fileName = "userdesk-\(token)"
        guard let path = url?.appendingPathComponent(fileName).path else {
            return nil
        }
        
        return path
    }
}

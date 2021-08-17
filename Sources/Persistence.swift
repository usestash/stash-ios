//
//  Persistence.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 23.07.2021.
//

import Foundation
import UIKit

struct PersistedProperties: Codable {
    var appVersion: String?
    var appRelease: String?
    var osVersion: String?
    var lastActiveUserDate: Date?
}

class Persistence {
    var properties: PersistedProperties!
    let token: String
    private let archiveQueue: DispatchQueue = DispatchQueue(label: "com.stashanalytics.persistenceQueue",
                                                            qos: .utility)

    init(token: String) {
        self.token = token
        if let previouslySavedProperties = loadPropertiesFromFile() {
            self.properties = previouslySavedProperties
        } else {
            let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            self.properties = PersistedProperties(appVersion: bundleVersion,
                                                  appRelease: appVersion,
                                                  osVersion: UIDevice.current.systemVersion)
        }
    }

    public func save() {
        archiveQueue.sync {
            savePropertiesToFile(properties: properties)
        }
    }

    private func savePropertiesToFile(properties: PersistedProperties) {
        guard let path = filePath(with: token) else {
            EventLogger.shared.warning("Could not create file path for archiving")
            return
        }

        do {
            let objectData = try PropertyListEncoder().encode(properties)
            let data = try NSKeyedArchiver.archivedData(withRootObject: objectData,
                                                        requiringSecureCoding: false)
            let fileUrl = URL(fileURLWithPath: path)
            try data.write(to: fileUrl)
        } catch {
            EventLogger.shared.error("Save to file failed: \(error)")
        }
    }

    private func loadPropertiesFromFile() -> PersistedProperties? {
        guard let path = filePath(with: token) else {
            EventLogger.shared.warning("Could not create archived file path")
            return nil
        }

        guard FileManager.default.fileExists(atPath: path) else {
            return nil
        }

        let fileUrl = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: fileUrl),
              let unarchivedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data,
              let properties = try? PropertyListDecoder().decode(PersistedProperties.self,
                                                                 from: unarchivedData) else {
            EventLogger.shared.error("Loading from file failed")
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

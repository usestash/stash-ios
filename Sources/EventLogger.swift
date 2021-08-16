//
//  EventLogger.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 24.07.2021.
//

import Foundation
import os

struct EventLogger {
    static let shared = EventLogger()
    private var logger = Logger(subsystem: "com.stash.analytics", category: "Stash")

    func info(_ message: String) {
        logger.info("Info - \(message)")
    }

    func debug(_ message: String) {
        logger.debug("Debug - \(message)")
    }

    func warning(_ message: String) {
        logger.warning("Warning - \(message)")
    }

    func error(_ message: String) {
        logger.error("Error - \(message)")
    }
}

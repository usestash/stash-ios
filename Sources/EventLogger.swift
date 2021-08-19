//
//  EventLogger.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 24.07.2021.
//

import Foundation
import os

/// Struct handling the logging of events.
struct EventLogger {
    
    /// The shared instance.
    static let shared = EventLogger()
    
    /// The logger instance/
    private var logger = Logger(subsystem: "com.stash.analytics", category: "Stash")
    
    /// Logs an info message.
    /// - Parameter message: The message.
    func info(_ message: String) {
        logger.info("Info - \(message)")
    }
    /// Logs a debug message.
    /// - Parameter message: The message.
    func debug(_ message: String) {
        logger.debug("Debug - \(message)")
    }
    /// Logs a warning message.
    /// - Parameter message: The message.
    func warning(_ message: String) {
        logger.warning("Warning - \(message)")
    }
    /// Logs an error message.
    /// - Parameter message: The message.
    func error(_ message: String) {
        logger.error("Error - \(message)")
    }
}

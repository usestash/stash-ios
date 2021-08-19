//
//  ScreenView.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 03.07.2021.
//

import Foundation

public class StashAnalytics {

    /// The application API key
    public var apiKey: String?

    /// The application identifier
    public var applicationIdentifier: String?
    
    /// The events handler instance.
    private var eventHandler: EventsHandler
    
    /// The publicly availabe instance.
    public static let main = StashAnalyticsInstance()
    
    /// Designated initializer.
    private init() {
        let cache = Cache<Event>()
        eventHandler = EventsHandler(cache: cache)
    }

    /// Registers the UserDesk api key and application identifier.
    /// - Parameters:
    ///   - apiKey: The user API key/
    ///   - applicationIdentifier: The application identifier.
    public static func initialize(apiKey: String, applicationIdentifier: String) {
        main.apiKey = apiKey
        main.applicationIdentifier = applicationIdentifier
    }
}

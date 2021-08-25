//
//  StashAnalyticsInstance.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 17.07.2021.
//

import Foundation
import UIKit

/// Class handling the events storage and upload.
public class StashAnalyticsInstance {
    /// The application API key
    internal var apiKey: String? {
        didSet {
            if let token = apiKey {
                persistence = Persistence(token: token)
            }
        }
    }

    /// The application identifier
    internal var applicationIdentifier: String?

    /// Events handlers
    private var eventsHandler: EventsHandler

    /// Flusher instance.
    private var flusher = Flusher()

    /// Request flusher that handles the sending data to the API.
    private var requestFlusher: RequestFlusher

    /// Persistence instance that serializes events to disk.
    private var persistence: Persistence?

    /// Global persisted properties that helps keep track of app  and os updates.
    private var persistedProperties: PersistedProperties? {
        get {
            persistence?.properties
        }
        set {
            persistence?.properties = newValue
        }
    }

    /// Designated initializer
    /// - Parameter urlSession: Optional URLSession instance, the shared one will be used if nothing is provided.
    init(urlSession: URLSession = URLSession.shared) {
        let cache = Cache<Event>()
        eventsHandler = EventsHandler(cache: cache)
        requestFlusher = RequestFlusher(cache: cache, urlSession: urlSession)
        flusher.delegate = requestFlusher

        setupListners()
    }

    /// Track a screen view event.
    /// - Parameters:
    ///   - screenName: The screen name.
    ///   - screenClass: The screen controller class.
    public func trackScreenView(screenName: String?, screenClass: String? = nil) {
        eventsHandler.trackScreenView(screenName: screenName,
                                      screenClass: screenClass)
        trackActiveUser()
    }

    /// Track an active user event.
    private func trackActiveUser() {
        if wasUserLastActiveToday() {
            eventsHandler.trackActiveUser()
        }
    }

    /// Track an app update event.
    public func trackAppUpdate() {
        eventsHandler.trackAppUpdate()
    }

    /// Track an os update event.
    public func trackOsUpdate() {
        eventsHandler.trackOsUpdate()
    }

    /// Track a custom event.
    /// - Parameter type: Event type.
    public func trackCustomEvent(type: String) {
        eventsHandler.trackCustomEvent(type: type)
    }

    /// Track an in app purchase event.
    /// - Parameters:
    ///   - value: The value of the in app purchase
    ///   - isRenewal: Flags if the in app purchase was a renewal.
    public func trackInAppPurchase(value: Double, isRenewal: Bool) {
        eventsHandler.trackInAppPurchase(value: value,
                                         isRenewal: isRenewal)
    }

    /// Track login event.
    /// - Parameter option: The login option (credential, social, etc.)
    public func trackLogin(option: String) {
        eventsHandler.trackLogin(option: option)
    }

    /// Track signup event.
    /// - Parameter option: The signup option (credential, social, etc.)
    public func trackSignup(option: String) {
        eventsHandler.trackSignup(option: option)
    }

    /// Track a notification open event.
    /// - Parameter content: The content of the notification.
    public func trackNotificationOpen(content: String) {
        eventsHandler.trackNotificationOpen(content: content)
    }

    /// Track a content selection event.
    /// - Parameter content: The content selected.
    public func trackSelectContent(content: String) {
        eventsHandler.trackSelectContent(content: content)
    }

    /// Tracks a share event.
    /// - Parameter content: The content shared.
    public func trackShare(content: String) {
        eventsHandler.trackShare(content: content)
    }

    /// Sets up the listeners for when the application becomes active / inactive.
    private func setupListners() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(self,
                                       selector: #selector(applicationDidBecomeActive(_:)),
                                       name: UIApplication.didBecomeActiveNotification,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(applicationWillResignActive(_:)),
                                       name: UIApplication.willResignActiveNotification,
                                       object: nil)
    }

    /// Delegate method called when the application has become active.
    /// - Parameter notification: The didBecomeActiveNotification.
    @objc private func applicationDidBecomeActive(_ notification: Notification) {
        flusher.startTimer()
        eventsHandler.startSession()
        verifyOsUpdate()
        verifyAppUpdate()
    }

    /// Delegate method called when the application has resigned active.
    /// - Parameter notification: The willResignActiveNotification.
    @objc private func applicationWillResignActive(_ notification: Notification) {
        flusher.stopTimer()
        eventsHandler.endSession()
        requestFlusher.flush(completion: nil)
        persistence?.save()
    }

    /// Checks if the application has been updated.
    private func verifyAppUpdate() {
        guard let storedAppVersion = persistedProperties?.appVersion,
              let currentAppVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return
        }
        if storedAppVersion != currentAppVersion {
            persistedProperties?.appVersion = currentAppVersion
            persistence?.save()
            eventsHandler.trackAppUpdate()
        }
    }

    /// Checks if the OS has been updated.
    private func verifyOsUpdate() {
        let currentOsVersion = UIDevice.current.systemVersion
        guard let storedOsVersion = persistedProperties?.osVersion else {
            return
        }
        if storedOsVersion != currentOsVersion {
            persistedProperties?.osVersion = currentOsVersion
            persistence?.save()
            eventsHandler.trackOsUpdate()
        }
    }

    /// Check if the user was last actice today.
    /// - Returns: True if the user was last actice today.
    private func wasUserLastActiveToday() -> Bool {
        let today = Date()
        guard let storedLastActiveDate = persistedProperties?.lastActiveUserDate else {
            updarteLastActiveUserDate()
            return false
        }
        updarteLastActiveUserDate()
        return NSCalendar.current.isDate(today, inSameDayAs: storedLastActiveDate)
    }

    /// Updates the last active date.
    private func updarteLastActiveUserDate() {
        persistedProperties?.lastActiveUserDate = Date()
        persistence?.save()
    }
}

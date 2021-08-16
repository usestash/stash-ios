//
//  StashAnalyticsInstance.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 17.07.2021.
//

import Foundation
import UIKit

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

    private var eventHandler: EventsHandler

    private var flusher = Flusher()
    private var requestFlusher: RequestFlusher
    private var persistence: Persistence?

    private var persistedProperties: PersistedProperties? {
        get {
            persistence?.properties
        }
        set {
            persistence?.properties = newValue
        }
    }

    init(urlSession: URLSession = URLSession.shared) {
        let cache = Cache<Event>()
        eventHandler = EventsHandler(cache: cache)
        requestFlusher = RequestFlusher(cache: cache, urlSession: urlSession)
        flusher.delegate = requestFlusher

        setupListners()
    }

    public func trackScreenView(screenName: String?, screenClass: String? = nil) {
        eventHandler.trackScreenView(screenName: screenName,
                                      screenClass: screenClass)
        trackActiveUser()
    }

    private func trackActiveUser() {
        if wasUserLastActiveToday() {
            eventHandler.trackActiveUser()
        }
    }

    public func trackAppUpdate() {
        eventHandler.trackAppUpdate()
    }

    public func trackOsUpdate() {
        eventHandler.trackOsUpdate()
    }

    public func trackCustomEvent(type: String) {
        eventHandler.trackCustomEvent(type: type)
    }

    public func trackInAppPurchase(value: Double, isRenewal: Bool) {
        eventHandler.trackInAppPurchase(value: value,
                                         isRenewal: isRenewal)
    }

    public func trackLogin(option: String) {
        eventHandler.trackLogin(option: option)
    }

    public func trackSignup(option: String) {
        eventHandler.trackSignup(option: option)
    }

    public func trackNotificationOpen(content: String) {
        eventHandler.trackNotificationOpen(content: content)
    }

    public func trackSelectContent(content: String) {
        eventHandler.trackSelectContent(content: content)
    }

    public func trackShare(content: String) {
        eventHandler.trackShare(content: content)
    }

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

    @objc private func applicationDidBecomeActive(_ notification: Notification) {
        flusher.startTimer()
        eventHandler.startSession()
        verifyOsUpdate()
        verifyAppUpdate()
    }

    @objc private func applicationWillResignActive(_ notification: Notification) {
        flusher.stopTimer()
        eventHandler.endSession()
        requestFlusher.flush(completion: nil)
        persistence?.save()
    }

    private func verifyAppUpdate() {
        guard let storedAppVersion = persistedProperties?.appVersion,
              let currentAppVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return
        }
        if storedAppVersion != currentAppVersion {
            persistedProperties?.appVersion = currentAppVersion
            persistence?.save()
            eventHandler.trackAppUpdate()
        }
    }

    private func verifyOsUpdate() {
        let currentOsVersion = UIDevice.current.systemVersion
        guard let storedOsVersion = persistedProperties?.osVersion else {
            return
        }
        if storedOsVersion != currentOsVersion {
            persistedProperties?.osVersion = currentOsVersion
            persistence?.save()
            eventHandler.trackOsUpdate()
        }
    }

    private func wasUserLastActiveToday() -> Bool {
        let today = Date()
        guard let storedLastActiveDate = persistedProperties?.lastActiveUserDate else {
            updarteLastActiveUserDate()
            return false
        }
        updarteLastActiveUserDate()
        return NSCalendar.current.isDate(today, inSameDayAs: storedLastActiveDate)
    }

    private func updarteLastActiveUserDate() {
        persistedProperties?.lastActiveUserDate = Date()
        persistence?.save()
    }
}

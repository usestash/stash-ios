//
//  EventsHandler.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 15.07.2021.
//

import Foundation
import CryptoKit
#if os(watchOS)
import WatchKit
#else
import UIKit
#endif

/// Class handling the creation and caching of events.
class EventsHandler {
    
    /// Cache storing the events.
    private var cache = Cache<Event>()
    
    /// When the  previous screen view started.
    private var previousScreenViewStartTime: Date?
    /// The previous screen view event.
    private var previousScreenView: Event?
    
    /// Tracks wheter a first event has occured.
    private var firstEventHasOccured = false
    
    /// When the session has started.
    private var sessionStart: Date!
    
    /// The current device code.
    private var deviceCode: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)

        let identifier = mirror.children.reduce("") { identifier, element in
          guard let value = element.value as? Int8, value != 0 else { return identifier }
          return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }()
    
    /// The OS name.
    private var osName: String = {
        UIDevice.current.systemName
    }()
    
    /// The OS version
    private var osVersion: String = {
        UIDevice.current.systemVersion
    }()
    
    /// The app version.
    private var appVersion: String = {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }()
    
    /// User signature.
    private var userSignature: String = {
        guard let identifier = UIDevice.current.identifierForVendor?.uuidString,
              let data = identifier.data(using: .utf8) else {
            return ""
        }
        
        return Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
    }()
    
    /// Designated initializer.
    /// - Parameter cache: The cache storing the events.
    init(cache: Cache<Event>) {
        self.cache = cache
    }
    
    /// Start the session.
    func startSession() {
        sessionStart = Date()
    }
    
    /// End the session.
    func endSession() {
        let sessionEnd = Date()
        let session = Event(type: "session",
                            deviceCode: deviceCode,
                            osName: osName,
                            osVersion: osVersion,
                            appVersion: appVersion)
        session.duration = Int(sessionEnd.timeIntervalSince(sessionStart))
        cache.save(object: session)
    }
    
    /// Track a screen view event.
    /// - Parameters:
    ///   - screenName: The screen name.
    ///   - screenClass: The screen controller class.
    func trackScreenView(screenName: String?, screenClass: String? = nil) {
        let screenView = Event(type: "screen_view",
                               deviceCode: deviceCode,
                               osName: osName,
                               osVersion: osVersion,
                               appVersion: appVersion)
        screenView.screenName = screenName
        screenView.screenClass = screenClass
        if let previousStartTime = previousScreenViewStartTime, let lastScreenView = previousScreenView {
            let time = abs(previousStartTime.timeIntervalSinceNow)
            lastScreenView.duration = Int(time)
            cache.save(object: lastScreenView)
        }
        previousScreenViewStartTime = Date()
        previousScreenView = screenView
        trackActiveUser()
    }
    
    /// Tracks an active user event.
    func trackActiveUser() {
        if firstEventHasOccured {
            return
        }
        let activeUser = Event(type: "active_user",
                               deviceCode: deviceCode,
                               osName: osName,
                               osVersion: osVersion,
                               appVersion: appVersion)
        activeUser.userSignature = userSignature
        cache.save(object: activeUser)
        firstEventHasOccured = true
    }
    
    /// Tracks an app update event.
    func trackAppUpdate() {
        let appUpdate = Event(type: "app_update",
                              deviceCode: deviceCode,
                              osName: osName,
                              osVersion: osVersion,
                              appVersion: appVersion)
        cache.save(object: appUpdate)
    }
    
    /// Tracks an os update event.
    func trackOsUpdate() {
        let osUpdate = Event(type: "os_update",
                             deviceCode: deviceCode,
                             osName: osName,
                             osVersion: osVersion,
                             appVersion: appVersion)
        cache.save(object: osUpdate)
    }
    
    /// Track a custom evetn.
    /// - Parameter type: The custom event type.
    func trackCustomEvent(type: String) {
        let event = Event(type: type,
                          deviceCode: deviceCode,
                          osName: osName,
                          osVersion: osVersion,
                          appVersion: appVersion)
        cache.save(object: event)
        trackActiveUser()
    }

    /// Track an in app purchase event.
    /// - Parameters:
    ///   - value: The value of the in app purchase
    ///   - isRenewal: Flags if the in app purchase was a renewal.
    func trackInAppPurchase(value: Double, isRenewal: Bool) {
        let inAppPurchase = Event(type: "in_app_purchase",
                                  deviceCode: deviceCode,
                                  osName: osName,
                                  osVersion: osVersion,
                                  appVersion: appVersion)
        inAppPurchase.value = value
        inAppPurchase.renewal = isRenewal
        cache.save(object: inAppPurchase)
    }
    
    /// Tracks a login event.
    /// - Parameter option: The login option (credential, social, etc.)
    func trackLogin(option: String) {
        let login = Event(type: "login",
                          deviceCode: deviceCode,
                          osName: osName,
                          osVersion: osVersion,
                          appVersion: appVersion)
        login.option = option
        cache.save(object: login)
        trackActiveUser()
    }
    
    /// Tracks a signup event.
    /// - Parameter option: The signup option (credential, social, etc.)
    func trackSignup(option: String) {
        let signup = Event(type: "sign_up",
                           deviceCode: deviceCode,
                           osName: osName,
                           osVersion: osVersion,
                           appVersion: appVersion)
        signup.option = option
        cache.save(object: signup)
        trackActiveUser()
    }
    /// Tracks a notification open event.
    /// - Parameter content: The content of the notification.
    func trackNotificationOpen(content: String) {
        let notificationOpen = Event(type: "notification_open",
                                     deviceCode: deviceCode,
                                     osName: osName,
                                     osVersion: osVersion,
                                     appVersion: appVersion)
        notificationOpen.content = content
        cache.save(object: notificationOpen)
        trackActiveUser()
    }
    
    /// Tracks a content selection event.
    /// - Parameter content: The content selected.
    func trackSelectContent(content: String) {
        let selectContent = Event(type: "select_content",
                                  deviceCode: deviceCode,
                                  osName: osName,
                                  osVersion: osVersion,
                                  appVersion: appVersion)
        selectContent.content = content
        cache.save(object: selectContent)
        trackActiveUser()
    }
    
    /// Tracks a share event.
    /// - Parameter content: The content shared.
    func trackShare(content: String) {
        let share = Event(type: "share",
                          deviceCode: deviceCode,
                          osName: osName,
                          osVersion: osVersion,
                          appVersion: appVersion)
        share.content = content
        cache.save(object: share)
        trackActiveUser()
    }
}

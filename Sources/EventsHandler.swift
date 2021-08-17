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

class EventsHandler {

    private var cache = Cache<Event>()
    private var previousScreenViewStartTime: Date?
    private var previousScreenView: Event?
    private var firstEventHasOccured = false

    private var sessionStart: Date!

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

    private var osName: String = {
        UIDevice.current.systemName
    }()

    private var osVersion: String = {
        UIDevice.current.systemVersion
    }()

    private var appVersion: String = {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }()
    
    private var userSignature: String = {
        guard let identifier = UIDevice.current.identifierForVendor?.uuidString,
              let data = identifier.data(using: .utf8) else {
            return ""
        }
        
        return Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
    }()

    init(cache: Cache<Event>) {
        self.cache = cache
    }

    func startSession() {
        sessionStart = Date()
    }

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

    func trackAppUpdate() {
        let appUpdate = Event(type: "app_update",
                              deviceCode: deviceCode,
                              osName: osName,
                              osVersion: osVersion,
                              appVersion: appVersion)
        cache.save(object: appUpdate)
    }

    func trackOsUpdate() {
        let osUpdate = Event(type: "os_update",
                             deviceCode: deviceCode,
                             osName: osName,
                             osVersion: osVersion,
                             appVersion: appVersion)
        cache.save(object: osUpdate)
    }

    func trackCustomEvent(type: String) {
        let event = Event(type: type,
                          deviceCode: deviceCode,
                          osName: osName,
                          osVersion: osVersion,
                          appVersion: appVersion)
        cache.save(object: event)
        trackActiveUser()
    }

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

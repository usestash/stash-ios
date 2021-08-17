//
//  Event.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 03.07.2021.
//

import Foundation

internal class Event: Codable {

    /// The code identifing the device, for example iPhone7,1
    var deviceCode: String

    /// The operating system name, iOS
    var osName: String

    /// The operating system version, 14.5
    var osVersion: String

    /// The application version
    var appVersion: String

    /// The event type
    var type: String

    /// A user hash based on the UIDevice vendor identifier
    var userSignature: String?

    /// The duration of the event
    var duration: Int?

    /// The option associated with the even, for example "social" for a login event
    var option: String?

    /// The value of the event
    var value: Double?

    /// If the event is a renewal - an in-app purchase for example
    var renewal: Bool?

    /// The content associated with the event
    var content: String?

    /// The event's screen name
    var screenName: String?

    /// The event's screen class
    var screenClass: String?

    init(type: String,
         deviceCode: String,
         osName: String,
         osVersion: String,
         appVersion: String) {
        self.deviceCode = deviceCode
        self.osName = osName
        self.osVersion = osVersion
        self.appVersion = appVersion
        self.type = type
    }
}

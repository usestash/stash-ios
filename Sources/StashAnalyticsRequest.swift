//
//  StashAnalyticsRequest.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 30/06/2020.
//  Copyright © 2020 StashAnalytics. All rights reserved.
//

import Foundation
import Combine

/// Protocol describing a request to the StashAnalytics API.
protocol StashAnalyticsRequest {
    ///
    func send(data: Data) -> AnyPublisher<Bool, Error>
    /// The application identifier offered by the service.
    var applicationIdentifier: String { get }
    /// The api key used to call the API.
    var apiKey: String { get }
}

extension StashAnalyticsRequest {
    var applicationIdentifier: String {
        return StashAnalytics.main.applicationIdentifier!
    }

    var apiKey: String {
        return StashAnalytics.main.apiKey!
    }
}

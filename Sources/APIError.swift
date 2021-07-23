//
//  NetworkError.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 30/06/2020.
//  Copyright © 2020 StashAnalytics. All rights reserved.
//

import Foundation

/// Enum of API Errors
internal enum APIError: Error {
    /// Encoding issue when trying to send data.
    case encodingError(String?)
    /// No data recieved from the server.
    case noData
    /// The server response was invalid (unexpected format).
    case invalidResponse
    /// The request was rejected: 400-499
    case badRequest(String?)
    /// Encountered a server error.
    case serverError(String?)
    /// There was an error parsing the data.
    case parseError(String?)
    /// Unknown error.
    case unknown
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .encodingError(let errorString):
            return errorString
        case .noData:
            return "No data"
        case .invalidResponse:
            return "Invalid response"
        case .badRequest(let errorString):
            return errorString
        case .serverError(let errorString):
            return errorString
        case .parseError(let errorString):
            return errorString
        case .unknown:
            return "Unknown error"
        }
    }
}

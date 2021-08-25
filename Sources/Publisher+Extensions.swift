//
//  Publisher+Extensions.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 18/07/2020.
//  Copyright © 2020 StashAnalytics. All rights reserved.
//

import Foundation
import Combine

// Extension hadling the API status code response.
internal extension Publisher where Output == (data: Data, response: URLResponse) {

    /// Returns a publisher based on the API response status code.
    /// - Returns: A publisher with the result of the upload as a bool and an error if it fails.
    func validateStatusCode() -> AnyPublisher<Output, APIError> {
        return self.mapError { .badRequest($0.localizedDescription) }
            .flatMap { result -> AnyPublisher<(data: Data, response: URLResponse), APIError> in
                return self.handleApiRequestError(result: result)
        }
        .eraseToAnyPublisher()
    }

    typealias APIRequestResult = (data: Data, response: URLResponse)
    typealias APIRequestPublisher = AnyPublisher<(data: Data, response: URLResponse), APIError>

    /// Determines based on the API status code response whether the request failed or succeeded.
    /// - Parameter result: The APIRequestResult.
    /// - Returns: APIRequestPublisher instance.
    private func handleApiRequestError(result: APIRequestResult) -> APIRequestPublisher {
        let statusCode = (result.response as? HTTPURLResponse)?.statusCode ?? -1
        let jsonData = result.data
        let error = try? JSONDecoder().decode(String.self, from: jsonData)
        switch statusCode {
        case 200...299:
            return Just(result)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        case 400...499:
            return Fail(error: APIError.badRequest(error))
                .eraseToAnyPublisher()
        case 500...599:
            return Fail(error: APIError.serverError(error))
                .eraseToAnyPublisher()
        default:
            return Fail(error: APIError.unknown)
                .eraseToAnyPublisher()
        }
    }
}

//
//  Publisher+Extensions.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 18/07/2020.
//  Copyright © 2020 StashAnalytics. All rights reserved.
//

import Foundation
import Combine

internal extension Publisher where Output == (data: Data, response: URLResponse) {
    func validateStatusCode() -> AnyPublisher<Output, APIError> {
        return self.mapError { .badRequest($0.localizedDescription) }
            .flatMap { result -> AnyPublisher<(data: Data, response: URLResponse), APIError> in
                return self.handleApiRequestError(result: result)
        }
        .eraseToAnyPublisher()
    }

    typealias APIRequestResult = (data: Data, response: URLResponse)
    typealias APIRequestPublisher = AnyPublisher<(data: Data, response: URLResponse), APIError>

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

//
//  Request.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 02.07.2021.
//

import Foundation
import Combine

class Request: StashAnalyticsRequest {

    let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func send(data: Data) -> AnyPublisher<Bool, Error> {
        let request = urlRequest(with: data)
        return urlSession.dataTaskPublisher(for: request)
            .retry(1)
            .validateStatusCode()
            .tryMap { result -> Bool in
                let statusCode = (result.response as? HTTPURLResponse)?.statusCode ?? -1
                return statusCode == 201
            }
            .eraseToAnyPublisher()
    }

    /// Creates a URLRequest from this instance.
    /// - Parameter environment: The environment against which the `URLRequest` must be constructed.
    /// - Returns: An optional `URLRequest`.
    private func urlRequest(with data: Data) -> URLRequest {
        // Create the base URL.
        let url = url(with: "http://api.use:3000")!
        // Create a request with that URL.
        var request = URLRequest(url: url)

        // Append all related properties.
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = data

        return request
    }

    /// Creates a URL with the given base URL.
    /// - Parameter baseURL: The base URL string.
    /// - Returns: An optional `URL`.
    private func url(with baseURL: String) -> URL? {
        // Create a URLComponents instance to compose the url.
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        // Add the request path to the existing base URL path
        urlComponents.path += path

        return urlComponents.url
    }

    private var headers: [String: String] {
        return ["Authorization": "Bearer \(apiKey)"]
    }

    private var path: String {
        "/v1/applications/\(applicationIdentifier)/events"
    }
}

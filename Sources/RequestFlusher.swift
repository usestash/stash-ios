//
//  RequestFlusher.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 18.07.2021.
//

import Foundation
import Combine

/// Class handling the flushing of events to the API.
class RequestFlusher: FlusherDelegate {
    
    /// Cache instance storing the events.
    private let cache: Cache<Event>
    
    /// URLSession instance handling the requests.
    private let urlSession: URLSession
    
    /// Request cancelable.
    private var requestCancelable: AnyCancellable?

    /// JSON Encoder.
    private let encoder = JSONEncoder()
    
    /// Designated initializer.
    /// - Parameters:
    ///   - cache: The cache storing the events.
    ///   - urlSession: The URLSession handling the API requests.
    init(cache: Cache<Event>, urlSession: URLSession) {
        self.cache = cache
        self.urlSession = urlSession
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    /// FlusherDelegate method.
    /// - Parameter completion: Callback - not used momentarly..
    func flush(completion: (() -> Void)?) {
        sendEvents()
    }
    
    /// Gets all the cached events and send them to the API.
    private func sendEvents() {
        guard let data = getCachedEvents() else {
            return
        }
        let request = Request(urlSession: urlSession)
        requestCancelable = request.send(data: data)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    EventLogger.shared.error(error.localizedDescription)
                case .finished:
                    EventLogger.shared.info("Data uploaded")
                }
        }, receiveValue: { [weak self] success in
            if success {
                self?.deleteCachedData()
            }
        })
    }
    
    /// Retrieves all cached events.
    /// - Returns: JSON encoded events.
    private func getCachedEvents() -> Data? {
        let events = ["events": cache.getAll()]
        var data: Data?
        do {
            data = try encoder.encode(events)
        } catch {
            EventLogger.shared.error("Encoding issue: \(error)")
        }

        return data
    }
    
    /// Deletes all the previously stored events.
    private func deleteCachedData() {
        cache.removeAll()
    }
}

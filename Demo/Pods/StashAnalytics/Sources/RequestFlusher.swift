//
//  RequestFlusher.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 18.07.2021.
//

import Foundation
import Combine

class RequestFlusher: FlusherDelegate {

    private let cache: Cache<Event>
    private let urlSession: URLSession
    private var requestCancelable: AnyCancellable?
    private let encoder = JSONEncoder()

    init(cache: Cache<Event>, urlSession: URLSession) {
        self.cache = cache
        self.urlSession = urlSession
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }

    func flush(completion: (() -> Void)?) {
        sendEvents()
    }

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

    private func deleteCachedData() {
        cache.removeAll()
    }
}

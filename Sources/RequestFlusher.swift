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
    private var requestCancelable: AnyCancellable? = nil
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
            .sink(receiveCompletion: { _ in
        }, receiveValue: { [weak self] success in
            if success {
                self?.deleteCachedData()
            }
        })
    }
    
    private func getCachedEvents() -> Data? {
        let events = ["events" : cache.getAll()]
        var data: Data? = nil
        do {
            data = try encoder.encode(events)
        } catch {
            print("Encoding issue: \(error)")
        }
        
        return data
    }
    
    private func deleteCachedData() {
        cache.removeAll()
    }    
}

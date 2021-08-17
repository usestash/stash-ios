//
//  Flusher.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 17.07.2021.
//

import Foundation

protocol FlusherDelegate: AnyObject {
    func flush(completion: (() -> Void)?)
}

class Flusher {
    private var timer: Timer?
    private var interval: Int = 30
    weak var delegate: FlusherDelegate?

    func startTimer() {
        stopTimer()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.interval),
                                              target: self,
                                              selector: #selector(self.beginFlush),
                                              userInfo: nil,
                                              repeats: true)
        }
    }

    func stopTimer() {
        if let timer = timer {
            DispatchQueue.main.async { [weak self, timer] in
                timer.invalidate()
                self?.timer = nil
            }
        }
    }

    @objc private func beginFlush() {
        delegate?.flush(completion: nil)
    }
}

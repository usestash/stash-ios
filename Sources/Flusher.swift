//
//  Flusher.swift
//  StashAnalytics
//
//  Created by Ciprian Redinciuc on 17.07.2021.
//

import Foundation

/// Protocol to which a flusher must conform.
protocol FlusherDelegate: AnyObject {
    func flush(completion: (() -> Void)?)
}

/// Class that fulshes events to a delegate in a given time interval.
class Flusher {
    /// Timer handling the triggering of flush events.
    private var timer: Timer?
    /// Timer interval.
    private var interval: Int = 30
    /// Delegate handling the event.
    weak var delegate: FlusherDelegate?

    /// Start the timer.
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

    /// Stop the timer.
    func stopTimer() {
        if let timer = timer {
            DispatchQueue.main.async { [weak self, timer] in
                timer.invalidate()
                self?.timer = nil
            }
        }
    }

    /// Start flushing events.
    @objc private func beginFlush() {
        delegate?.flush(completion: nil)
    }
}

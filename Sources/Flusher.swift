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
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval),
                                     target: self,
                                     selector: #selector(self.beginFlush),
                                     userInfo: nil,
                                     repeats: true)
    }

    func stopTimer() {
        if let timer = timer {
            timer.invalidate()
        }
    }

    @objc private func beginFlush() {
        delegate?.flush(completion: nil)
    }
}

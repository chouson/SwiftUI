//
//  CountdownTimerTool.swift
//  CombineDemo
//
//  Created by Chouson on 2024/1/20.
//

import Foundation
import Combine

class CountdownTimerTool: ObservableObject {
    @Published private(set) var countdownTime: Int
    @Published private(set) var isEnd: Bool = true
    private(set) var originTime: Int
    private var cancellable: AnyCancellable? = nil
    
    init(countdownTime: Int) {
        self.countdownTime = countdownTime
        self.originTime = countdownTime
    }
    
    func start() {
        isEnd = false
        cancellable = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.countdownTime > 0 {
                    self.countdownTime -= 1
                } else {
                    reset()
                }
            }
    }
    
    func stop() {
        cancellable?.cancel()
    }
    
    func reset() {
        countdownTime = originTime
        isEnd = true
        stop()
    }
}

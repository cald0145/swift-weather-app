//
//  TimeManager.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-12.
//

import Combine
import Foundation

// manages time updates for the app
class TimeManager: ObservableObject {
    @Published var currentTime = Date()
    private var timer: AnyCancellable?

    init() {
        // create a timer that fires every minute
        timer = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.currentTime = Date()
            }
    }

    // format time for a specific timezone offset
    func formatTime(for timezoneOffset: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        // calculate local time using the offset
        let localTime = Date().addingTimeInterval(TimeInterval(timezoneOffset))
        return formatter.string(from: localTime)
    }
}

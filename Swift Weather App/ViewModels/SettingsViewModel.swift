//
//  SettingsViewModel.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-12.
//

import Foundation

class SettingsViewModel: ObservableObject {
    // refresh intervals in seconds
    static let refreshIntervals = [100, 300, 600, 900, 1800, 3600] // 5, 10, 15, 30, 60 minutes

    // selected refresh interval, defaults to 15 minutes
    @Published var selectedRefreshInterval: Int {
        didSet {
            UserDefaults.standard.set(selectedRefreshInterval, forKey: "refreshInterval")
        }
    }

    init() {
        // load saved interval or use default
        self.selectedRefreshInterval = UserDefaults.standard.integer(forKey: "refreshInterval")
        if selectedRefreshInterval == 0 {
            self.selectedRefreshInterval = 900 // 15 minutes default
        }
    }

    // convert seconds to minutes for display
    func intervalInMinutes(_ seconds: Int) -> Int {
        return seconds / 60
    }
}

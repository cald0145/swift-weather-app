//
//  WeatherViewModel.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-11-29.
//

import Foundation
import SwiftUI

// manages the weather data and business logic
@MainActor
class WeatherViewModel: ObservableObject {
    // published properties will automatically update the ui
    @Published var savedCities: [WeatherData] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // temporary initialization with sample data
    init() {
        // add sample data for testing
        savedCities = [
            WeatherData(cityName: "Ottawa", temperature: -1, condition: "Mostly Clear", localTime: Date()),
            WeatherData(cityName: "Santo Domingo", temperature: 26, condition: "Cloudy", localTime: Date()),
            WeatherData(cityName: "Buenos Aires", temperature: 19, condition: "Drizzle", localTime: Date()),
            WeatherData(cityName: "Barcelona", temperature: 8, condition: "Feels like 5", localTime: Date())
        ]
    }

    // function to format the time for display
    func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    // function to remove a city
    func removeCity(_ city: WeatherData) {
        savedCities.removeAll { $0.id == city.id }
    }
}

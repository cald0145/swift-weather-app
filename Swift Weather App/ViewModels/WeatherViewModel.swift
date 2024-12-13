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
    @Published var savedCities: [WeatherData] = []
    @Published var searchResults: [WeatherData] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let weatherService = WeatherService()
    private var updateTimer: Timer?
    private var timeUpdateTimer: Timer?
    
    // start temperature update timer
    func startWeatherUpdates() {
        // cancel existing timer
        updateTimer?.invalidate()
            
        // get interval from settings
        let interval = UserDefaults.standard.integer(forKey: "refreshInterval")
            
        // create new timer
        updateTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true) { [weak self] _ in
            Task {
                await self?.updateAllCities()
            }
        }
    }
    
        
    // update all cities weather data
    private func updateAllCities() async {
        for (index, city) in savedCities.enumerated() {
            if let updatedCity = try? await weatherService.searchCity(city.cityName).first {
                savedCities[index] = updatedCity
            }
        }
    }
        

    // search cities using the api
    func searchCities(query: String) async {
        guard !query.trimmed.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            searchResults = try await weatherService.searchCity(query)
            if searchResults.isEmpty {
                errorMessage = "Oops, make sure to enter the city name correctly!"
            }
        } catch {
            errorMessage = "Sorry, no city found. Please try again."
            searchResults = []
        }
        
        isLoading = false
    }
    
    // add city to saved list
    func addCity(_ city: WeatherData) {
        if !savedCities.contains(where: { $0.cityName == city.cityName }) {
            savedCities.append(city)
        }
    }
    
    // remove city from saved list
    func removeCity(_ city: WeatherData) {
        savedCities.removeAll { $0.id == city.id }
    }
    
    deinit {
        updateTimer?.invalidate()
        timeUpdateTimer?.invalidate()
    }
}

// string extension for trimming
extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

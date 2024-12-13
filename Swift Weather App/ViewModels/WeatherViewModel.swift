//
//  WeatherViewModel.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-11-29.
//

import Foundation
import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var savedCities: [WeatherData] = []
    @Published var searchResults: [WeatherData] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let weatherService = WeatherService()
    private var updateTimer: Timer?
    private var timeUpdateTimer: Timer?
    
    func getDetailedWeatherData(for city: WeatherData) async throws -> WeatherData {
        isLoading = true
        errorMessage = nil
        
        do {
            print("Fetching detailed weather for: \(city.cityName)")
            print("Coordinates: lat: \(city.coordinates.latitude), lon: \(city.coordinates.longitude)")
            
            let detailedData = try await weatherService.fetchDetailedWeather(
                lat: city.coordinates.latitude,
                lon: city.coordinates.longitude
            )
            isLoading = false
            return detailedData
        } catch {
            isLoading = false
            print("Error fetching detailed weather: \(error)")
            errorMessage = "Failed to fetch detailed weather data: \(error.localizedDescription)"
            throw error
        }
    }
    
    // reorder
        func reorderCities(fromOffsets source: IndexSet, toOffset destination: Int) {
            savedCities.move(fromOffsets: source, toOffset: destination)
        }
    
    // refresh all cities weather data
    func refreshWeatherData() async {
        isLoading = true
        errorMessage = nil
            
        do {
            // update each city's weather data
            var updatedCities: [WeatherData] = []
            for city in savedCities {
                let updated = try await weatherService.fetchDetailedWeather(
                    lat: city.coordinates.latitude,
                    lon: city.coordinates.longitude
                )
                updatedCities.append(updated)
            }
            savedCities = updatedCities
        } catch {
            errorMessage = "Failed to refresh weather data: \(error.localizedDescription)"
        }
            
        isLoading = false
    }
    
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

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
    @Published var errorMessage: String?
    
    private let weatherService = WeatherService()
    
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
        } catch {
            errorMessage = "failed to search cities: \(error.localizedDescription)"
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
}

// string extension for trimming
extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

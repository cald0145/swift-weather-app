//
//  CitiesService.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-12.
//

import Foundation

actor CitiesService {
    // base url for the cities api
    private let baseURL = "https://countriesnow.space/api/v0.1"
    
    // response models for cities api
    struct CitiesResponse: Codable {
        let error: Bool
        let msg: String
        let data: [CountryData]
    }
    
    struct CountryData: Codable {
        let country: String
        let cities: [String]
    }
    
    // fetch all cities from the api
    func fetchAllCities() async throws -> [CountryData] {
        guard let url = URL(string: "\(baseURL)/countries") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(CitiesResponse.self, from: data)
        return response.data
    }
}

//
//  Enviroment.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-12.
//

// handle environment variables and configuration
import Foundation

enum Environment {
    // fetch environment variables
    static let weatherApiKey: String = {
        guard let apiKey = Bundle.main.infoDictionary?["OPENWEATHER_API_KEY"] as? String else {
            fatalError("Weather API not found in configuration.")
        }
        return apiKey
    }()
}

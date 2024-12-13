//
//  Enviroment.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-12.
//

import Foundation

enum Config {
    // fetch api key from configuration
    static var openWeatherAPIKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENWEATHER_API_KEY") as? String,
              apiKey != "$(OPENWEATHER_API_KEY)",
              !apiKey.isEmpty
        else {
            fatalError("OpenWeather API key not configured. Please check Config.xcconfig")
        }
        return apiKey
    }
}

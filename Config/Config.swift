//
//  Enviroment.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-12.
//

// handle environment variables and configuration
import Foundation

enum Config {
    // fetch api key from info.plist which gets it from xcconfig
    static var openWeatherAPIKey: String {
        // use a default value for development to prevent crash
        Bundle.main.infoDictionary?["OPENWEATHER_API_KEY"] as? String ?? "development_key"
    }
}

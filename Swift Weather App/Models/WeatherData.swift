//
//  WeatherData.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-11-29.
//

import Foundation

// represents the core weather data for a city
struct WeatherData: Identifiable, Codable {
    let id: UUID
    let cityName: String
    var temperature: Double
    var condition: String
    var weatherIcon: String
    var uvIndex: Double
    var windSpeed: Double
    var humidity: Double
    let timezone: Int

    var localTime: Date {
        let currentUTC = Date()
        return currentUTC.addingTimeInterval(TimeInterval(timezone))
    }

    // initializer with default values
    init(
        id: UUID = UUID(),
        cityName: String,
        temperature: Double = 0.0,
        condition: String = "",
        weatherIcon: String = "sun.max.fill",

        uvIndex: Double = 0.0,
        windSpeed: Double = 0.0,
        humidity: Double = 0.0,
        timezone: Int = 0
    ) {
        self.id = id
        self.cityName = cityName
        self.temperature = temperature
        self.condition = condition
        self.weatherIcon = weatherIcon
        self.uvIndex = uvIndex
        self.windSpeed = windSpeed
        self.humidity = humidity
        self.timezone = timezone
    }
}

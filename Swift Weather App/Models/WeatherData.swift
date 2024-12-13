//
//  WeatherData.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-11-29.
//

import CoreLocation
import Foundation
import SwiftUI

// represents the core weather data for a city
struct WeatherData: Identifiable, Codable, Hashable {
    let id: UUID
    let cityName: String
    var temperature: Double
    var condition: String
    var weatherIcon: String
    var uvIndex: Double
    var windSpeed: Double
    var humidity: Double
    let timezone: Int
    var hourlyForecast: [HourlyForecast]
    var coordinates: Coordinates

    // coordinate structure for map
    struct Coordinates: Codable, Hashable {
        let latitude: Double
        let longitude: Double

        var location: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }

    // hourly forecast data
    struct HourlyForecast: Identifiable, Codable, Hashable {
        var id: UUID = .init()
        let time: Date
        let temperature: Double
        let condition: String
        let icon: String
    }

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
        timezone: Int = 0,
        coordinates: Coordinates = Coordinates(latitude: 0.0, longitude: 0.0),
        hourlyForecast: [HourlyForecast] = []
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
        self.coordinates = coordinates
        self.hourlyForecast = hourlyForecast
    }
}

// determine background color based on temperature
extension WeatherData {
    var temperatureColor: Color {
        let normalizedTemp = (temperature + 20) / 60 // normalize temp from -20 to 40
        let clampedTemp = max(0, min(1, normalizedTemp))

        // interpolate between blue (cold) and red (hot)
        return Color(
            red: clampedTemp,
            green: 0.4 * (1 - clampedTemp),
            blue: 1 - clampedTemp,
            opacity: 0.7
        )
    }
}

//
//  WeatherService.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-11.
//

import Foundation

// handles all api calls to openweather
actor WeatherService {
    
    //// FOR VLADIMIR: put your openweather api key here!
    ///
    private let apiKey = "OPENWEATHER_API_KEY"
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    
    // search for cities
    func searchCity(_ query: String) async throws -> [WeatherData] {
        let endpoint = "\(baseURL)/weather"
        let queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let weatherResponse = try decoder.decode(OpenWeatherResponse.self, from: data)
        
        return [WeatherData(
            cityName: weatherResponse.name,
            temperature: weatherResponse.main.temp,
            condition: weatherResponse.weather.first?.description ?? "",
            weatherIcon: mapWeatherIcon(weatherResponse.weather.first?.icon ?? "")
        )]
    }
    
    // map openweather icons to sf symbols
    private func mapWeatherIcon(_ icon: String) -> String {
        switch icon {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "cloud.fill"
        case "09d", "09n": return "cloud.rain.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d", "11n": return "cloud.bolt.rain.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "sun.max.fill"
        }
    }
}

// models for api response
struct OpenWeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
}

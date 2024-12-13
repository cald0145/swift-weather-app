import Foundation

actor WeatherService {
    private let apiKey: String = "OPENWEATHER_API_KEY"
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
        
        // updated to include coordinates
        return [WeatherData(
            cityName: weatherResponse.name,
            temperature: weatherResponse.main.temp,
            condition: weatherResponse.weather.first?.description ?? "",
            weatherIcon: mapWeatherIcon(weatherResponse.weather.first?.icon ?? ""),
            timezone: weatherResponse.timezone,
            coordinates: WeatherData.Coordinates(
                latitude: weatherResponse.coord.lat,
                longitude: weatherResponse.coord.lon
            )
        )]
    }
    
    func fetchDetailedWeather(lat: Double, lon: Double) async throws -> WeatherData {
        let endpoint = "\(baseURL)/onecall"
        let queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "exclude", value: "minutely,daily,alerts")
        ]
        
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(OpenWeatherOneCallResponse.self, from: data)
        
        // map response to weather data
        return WeatherData(
            cityName: response.timezone,
            temperature: response.current.temp,
            condition: response.current.weather.first?.description ?? "",
            weatherIcon: mapWeatherIcon(response.current.weather.first?.icon ?? ""),
            uvIndex: response.current.uvi,
            windSpeed: response.current.windSpeed,
            humidity: response.current.humidity,
            timezone: response.timezoneOffset,
            coordinates: WeatherData.Coordinates(
                latitude: lat,
                longitude: lon
            ),
            hourlyForecast: response.hourly.prefix(6).map { hourly in
                WeatherData.HourlyForecast(
                    time: Date(timeIntervalSince1970: hourly.dt),
                    temperature: hourly.temp,
                    condition: hourly.weather.first?.description ?? "",
                    icon: mapWeatherIcon(hourly.weather.first?.icon ?? "")
                )
            }
        )
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
    let timezone: Int
    let coord: Coordinates // add this
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
    
    struct Coordinates: Codable {
        let lat: Double
        let lon: Double
    }
}

// separate response model for onecall api
struct OpenWeatherOneCallResponse: Codable {
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Hourly]
    
    struct Current: Codable {
        let temp: Double
        let humidity: Double
        let uvi: Double
        let windSpeed: Double
        let weather: [Weather]
    }
    
    struct Hourly: Codable {
        let dt: TimeInterval
        let temp: Double
        let weather: [Weather]
    }
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
}

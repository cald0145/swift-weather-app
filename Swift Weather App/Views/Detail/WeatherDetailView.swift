//
//  WeatherDetailView.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-12.
//

import MapKit
import SwiftUI

struct WeatherDetailView: View {
    let weather: WeatherData
    @Environment(\.dismiss) private var dismiss
    @State private var region: MKCoordinateRegion
    
    init(weather: WeatherData) {
        self.weather = weather
        // initialize map region
        _region = State(initialValue: MKCoordinateRegion(
            center: weather.coordinates.location,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        ZStack {
            // map background
            Map(coordinateRegion: $region, showsUserLocation: true)
                .ignoresSafeArea()
            
            // temperature-based overlay
            weather.temperatureColor
                .ignoresSafeArea()
            
            // weather content
            VStack(spacing: 20) {
                // header with city name and date
                VStack {
                    Text(weather.cityName)
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text(formatDate(Date()))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                // temperature display
                TemperatureView(temperature: weather.temperature)
                
                Spacer()
                
                // weather metrics
                WeatherMetricsView(
                    uvIndex: weather.uvIndex,
                    windSpeed: weather.windSpeed,
                    humidity: weather.humidity
                )
                
                // hourly forecast
                HourlyForecastView(forecast: weather.hourlyForecast)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // location permission will be implemented later
                }) {
                    Image(systemName: "location")
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy - MMM - d"
        return formatter.string(from: date)
    }
}

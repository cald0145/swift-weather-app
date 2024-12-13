//
//  HourlyForecastView.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-12.
//

import SwiftUI

struct HourlyForecastView: View {
    let forecast: [WeatherData.HourlyForecast]
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(forecast) { hour in
                        VStack(spacing: 8) {
                            Text(formatHour(hour.time))
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Image(systemName: hour.icon)
                                .font(.title2)
                                .foregroundColor(.white)
                            
                            Text("\(Int(round(hour.temperature)))°")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
            }
        }
        .background(.white.opacity(0.2))
        .cornerRadius(15)
    }
    
    private func formatHour(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

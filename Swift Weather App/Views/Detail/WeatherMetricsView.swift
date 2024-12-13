//
//  WeatherMetricsView.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-12.
//

import SwiftUI

struct WeatherMetricsView: View {
    let uvIndex: Double
    let windSpeed: Double
    let humidity: Double

    var body: some View {
        HStack {
            MetricItem(
                icon: "sun.max.fill",
                value: String(format: "%.0f", uvIndex),
                title: "UV Index"
            )
            Divider()
                .background(.white)
                .frame(height: 40)
            MetricItem(
                icon: "wind",
                value: "\(Int(windSpeed)) m/s",
                title: "Wind"
            )
            Divider()
                .background(.white)
                .frame(height: 40)
            MetricItem(
                icon: "humidity",
                value: "\(Int(humidity))%",
                title: "Humidity"
            )
        }
        .padding()
        .background(.white.opacity(0.2))
        .cornerRadius(15)
    }
}

struct MetricItem: View {
    let icon: String
    let value: String
    let title: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
}

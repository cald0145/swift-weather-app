//
//  TemperatureView.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-12.
//

import SwiftUI

struct TemperatureView: View {
    let temperature: Double
    @State private var isCelsius = true

    private var formattedTemperature: String {
        let temp = isCelsius ? temperature : (temperature * 9 / 5 + 32)
        return "\(Int(round(temp)))°\(isCelsius ? "C" : "F")"
    }

    var body: some View {
        Text(formattedTemperature)
            .font(.system(size: 96, weight: .thin))
            .foregroundColor(.white)
            .onTapGesture {
                withAnimation {
                    isCelsius.toggle()
                }
            }
    }
}

//
//  CityListView.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-11-29.
//

import SwiftUI

struct CityListView: View {
    // observe the view model for changes
    @StateObject var viewModel = WeatherViewModel()
    
    // state to control search sheet presentation
    @State private var isShowingSearch = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)), Color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // main content
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.savedCities) { city in
                            CityWeatherCard(city: city, onDelete: {
                                viewModel.removeCity(city)
                            })
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Jay's Weather App")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isShowingSearch = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
                            
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Text("Settings")) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.white)
                    }
                }
            }
            // move sheet modifier to the correct level
            .sheet(isPresented: $isShowingSearch) {
                SearchView(viewModel: viewModel)
            }
        }
    }
}

// represents a single city weather card
struct CityWeatherCard: View {
    let city: WeatherData
    let onDelete: () -> Void
    
    // note: remove @ObservedObject since we don't need to observe changes here
    // we'll use a static formatting method instead
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // delete button
            HStack {
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .opacity(0.7)
                }
            }
            
            // temperature and weather icon
            HStack(alignment: .top) {
                Text("\(Int(city.temperature))°C")
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: city.weatherIcon)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            
            // city name and time
            Text(city.cityName)
                .font(.title2)
                .foregroundColor(.white)
            
            // using static date formatter
            Text(Self.formatTime(date: city.localTime))
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            
            Text(city.condition)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    // helper method to format time
    private static func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// preview provider for swiftui canvas
struct CityListView_Previews: PreviewProvider {
    static var previews: some View {
        CityListView()
    }
}

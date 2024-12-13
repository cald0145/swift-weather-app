//
//  CityListView.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-11-29.
//

import SwiftUI

struct CityListView: View {
    // observe the view model for weather data updates
    @ObservedObject var viewModel: WeatherViewModel
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    // state to control search sheet presentation
    @State private var isShowingSearch = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // gradient extends to edges
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),
                        Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                // scrollable list of city cards
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
            // navigation bar styling
            .navigationTitle("Jay's Weather App")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Jay's Weather App")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { isShowingSearch = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $isShowingSearch) {
                SearchView(viewModel: viewModel)
            }
            .onAppear {
                // weather updates when view is shown
                viewModel.startWeatherUpdates()
            }
        }
    }
    
    // city weather card
    struct CityWeatherCard: View {
        let city: WeatherData
        let onDelete: () -> Void
        @StateObject private var timeManager = TimeManager()
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // main content row with all weather information
                HStack(alignment: .center) {
                    // city name and condition
                    VStack(alignment: .leading, spacing: 4) {
                        Text(city.cityName)
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(city.condition.capitalized)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(timeManager.formatTime(for: city.timezone))
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // weather icon and temperature
                    HStack(spacing: 15) {
                        Image(systemName: city.weatherIcon)
                            .font(.system(size: 45))
                            .foregroundColor(.white)
                            .frame(width: 45)
                        
                        // temperature display with smaller celsius symbol
                        HStack(alignment: .top, spacing: 2) {
                            Text("\(Int(city.temperature))")
                                .font(.system(size: 48, weight: .medium))
                            Text("°C")
                                .font(.system(size: 20))
                                .offset(y: 8)
                        }
                        .foregroundColor(.white)
                    }
                }
                
                // delete button aligned to the right!
                HStack {
                    Spacer()
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(15)
            .padding(.horizontal)
        }
        
        // helper method to format the time display
        private static func formatTime(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }
    }
    
    // preview provider for development
    struct CityListView_Previews: PreviewProvider {
        static var previews: some View {
            CityListView(viewModel: WeatherViewModel())
        }
    }
}

//
//  SearchView.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-11.
//

import SwiftUI

struct SearchView: View {
    // environment values
    @Environment(\.dismiss) var dismiss: DismissAction
    
    // view model for handling weather data and city operations
    @ObservedObject var viewModel: WeatherViewModel
    
    // state for search input
    @State private var searchText = ""
    
    // predefined list of popular cities for quick access
    private let popularCities = ["Toronto", "New York", "Dubai", "London"]
    
    // init public by default
    init(viewModel: WeatherViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ZStack {
                // create a gradient background for visual appeal
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(#colorLiteral(red: 0.4, green: 0.6, blue: 0.9, alpha: 1)),
                        Color(#colorLiteral(red: 0.2, green: 0.3, blue: 0.7, alpha: 1))
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // fixed top section with search and popular cities!!!
                    VStack(spacing: 20) {
                        // search input field with magnifying glass icon
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search for a city!", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onChange(of: searchText, initial: false) { _, newValue in
                                    Task {
                                        await viewModel.searchCities(query: newValue)
                                    }
                                }
                        }
                        .padding()
                        
                        // popular cities quick select section
                        VStack(alignment: .leading) {
                            Text("Popular Cities")
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(popularCities, id: \.self) { city in
                                        Button {
                                            Task {
                                                await addPopularCity(city)
                                            }
                                        } label: {
                                            Text(city)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(Color.white.opacity(0.2))
                                                .cornerRadius(20)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                    .background(Color.clear)
                    
                    // scrollable content area
                    ScrollView {
                        VStack(spacing: 20) {
                            // status and results section
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else if let error = viewModel.errorMessage {
                                Text(error)
                                    .foregroundColor(.red.opacity(0.8))
                                    .padding()
                            } else if !searchText.isEmpty {
                                // show search results
                                ForEach(viewModel.searchResults) { city in
                                    CityRowView(city: city) {
                                        viewModel.addCity(city)
                                        dismiss()
                                    }
                                }
                            } else {
                                // show recent searches or welcome message
                                Text("Type to search for a city")
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding()
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("Search for a city!")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    // helper function for adding a city from search
    private func addPopularCity(_ cityName: String) async {
        await viewModel.searchCities(query: cityName)
        if let city = viewModel.searchResults.first {
            viewModel.addCity(city)
            dismiss()
        }
    }
}

// helper view for city row in search results
struct CityRowView: View {
    let city: WeatherData
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                Text(city.cityName)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "plus")
                    .foregroundColor(.white)
            }
            .padding()
        }
        Divider()
            .background(Color.white.opacity(0.2))
    }
}

// end of file

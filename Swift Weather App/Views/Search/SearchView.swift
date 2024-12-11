//
//  SearchView.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-11.
//

import SwiftUI

struct SearchView: View {
    // environment values
    @Environment(\.dismiss) private var dismiss
    
    // view model for handling weather data and city operations
    @ObservedObject var viewModel: WeatherViewModel
    
    // state for handling search input
    @State private var searchText = ""
    
    // predefined list of popular cities for quick access
    private let popularCities = ["Tehran", "New York", "Dubai", "London"]
    
    // init is now public by default
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
                
                VStack(spacing: 20) {
                    // search input field with magnifying glass icon
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search for a city...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            // trigger search when text changes using new ios 17 syntax
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
                        
                        // horizontal scrolling list of popular cities
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
                    
                    // search results section with loading and error states
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        // scrollable list of search results
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(viewModel.searchResults) { city in
                                    Button {
                                        viewModel.addCity(city)
                                        dismiss()
                                    } label: {
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
                        }
                    }
                }
            }
            .navigationTitle("Search for City")
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
    
    // helper function to handle selection of popular cities
    private func addPopularCity(_ cityName: String) async {
        // search for the city and add the first result
        await viewModel.searchCities(query: cityName)
        if let city = viewModel.searchResults.first {
            viewModel.addCity(city)
            dismiss()
        }
    }
}

// end of file

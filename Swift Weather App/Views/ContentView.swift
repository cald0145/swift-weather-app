//
//  ContentView.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-11-21.
//

import SwiftUI

struct ContentView: View {
    // create a shared view model instance
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        // pass the view model to city list view
        CityListView(viewModel: viewModel)
            // load default cities when view appears
            .task {
                // add popular cities on first launch
                await loadDefaultCities()
            }
    }

    // helper function to load default cities
    private func loadDefaultCities() async {
        let defaultCities = ["Toronto", "Dubai", "London", "New York"]

        // search and add each city
        for cityName in defaultCities {
            await viewModel.searchCities(query: cityName)
            if let city = viewModel.searchResults.first {
                viewModel.addCity(city)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// REMEMBER REMOVE API KEY!!!!

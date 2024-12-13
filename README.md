# Swift Weather App

A simple yet intuitive weather application built with SwiftUI that provides real-time weather information for multiple cities using the OpenWeather API.
This was created for my MAD9137 class Final Project!

## Features

- Real-time weather updates!
- City search with popular cities suggestions
- Hourly weather forecasts
- Customizable refresh intervals
- Swipe-to-delete and drag-to-reorder city list

## API Key Setup

This app requires an OpenWeather API key to function. To set up your API key:

1. Sign up for an API key at [OpenWeather](https://openweathermap.org/api)
2. In the project:
   - Replace `OPENWEATHER_API_KEY` in WeatherService.swift with your API key
   - Never commit your actual API key!!!!!!

## Additional Features

- Local time display for each city
- Error handling and loading states
- Easter egg in About view
- Custom app icons for different states
- Built with SwiftUI and follows MVVM architecture
- Uses async/await for API calls
- Implements proper error handling

## Requirements

- OpenWeather API key

## Installation

1. Clone the repository
2. Set up your API key as described above
3. Open `Swift Weather App.xcodeproj`
4. Build and run the project

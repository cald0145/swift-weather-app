//
//  SettingsView.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-12.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        // main content
        ZStack {
            // gradient background matching main view
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),
                    Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                // refresh interval section
                VStack(spacing: 0) {
                    Text("Weather Refresh Interval")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.top, 20)
                        .padding(.bottom, 10)

                    Picker("Refresh Interval", selection: $settingsViewModel.selectedRefreshInterval) {
                        ForEach(SettingsViewModel.refreshIntervals, id: \.self) { interval in
                            Text("\(settingsViewModel.intervalInMinutes(interval)) minutes")
                                .tag(interval)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 150)
                }
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
                .padding(.top, 20)

                // about navigation
                NavigationLink(destination: AboutView()) {
                    HStack {
                        Text("About")
                            .foregroundColor(.white)
                            .font(.headline)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                }
                .padding(.horizontal)
                .padding(.top, 30)

                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

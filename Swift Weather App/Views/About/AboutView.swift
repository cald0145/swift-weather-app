//
//  AboutView.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-12.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
            
            // about content
            VStack(spacing: 20) {
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .padding()
                
                Text("Swift Weather App")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("Version 1.0")
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Created by Jay Calderon")
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top)
                
                Text("MAD9137 Final Project")
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top)
                
                Text("© 2024 All rights reserved")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.top, 40)
            }
            .padding()
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("About")
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

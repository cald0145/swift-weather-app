//
//  AboutView.swift
//  Swift Weather App
//
//  Created by Jay Calderon on 2024-12-12.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var tapCount = 0
    @State private var showEasterEgg = false
    
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
                // profile image with easter egg
                Image(showEasterEgg ? "baby-jay" : "jay-profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
                    .padding()
                    .onTapGesture {
                        tapCount += 1
                        if tapCount >= 3 {
                            withAnimation(.spring()) {
                                showEasterEgg.toggle()
                            }
                            tapCount = 0
                        }
                    }
                
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

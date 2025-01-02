//
//  LandingPageView.swift
//  Memora
//
//  Created by Bryant Martinez on 12/8/24.
//  Updated by Bryant Martinez For Color And Dark Mode on 12/9/24

import SwiftUI

struct LandingPageView: View {
    @State private var isInfoSheetPresented = false // State to track if the Info sheet is shown
    @EnvironmentObject var themeManager: ThemeManager // Access the global dark mode state

    var body: some View {
        NavigationView {
            ZStack {
                // Background color based on dark mode
                (themeManager.isDarkMode ? Color.black.opacity(0.8) : Color.white)
                    .ignoresSafeArea()

                VStack {
                    Text("Memora")
                        .font(.custom("AvenirNext-Bold", size: 50))
                        .foregroundColor(themeManager.isDarkMode ? .white : .blue)
                        .padding(.top, 10)

                    // Image with reduced size to fit in the center
                    Image(.memora4) // Replace with your image name
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400) // Adjust the size of the image to be smaller
                        .padding(.top, 20)

                    Spacer() // Pushes buttons towards the bottom

                    VStack(spacing: 20) {
                        // NavigationLink for "Let's Learn"
                        NavigationLink(destination: ContentView()) {
                            Text("Let's Learn")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding()
                                .foregroundColor(.white)
                                .background(themeManager.isDarkMode ? Color.gray.opacity(0.5) : Color.blue)
                                .cornerRadius(10)
                        }

                        // "Info!" button to present a sheet
                        Button(action: {
                            isInfoSheetPresented.toggle()
                        }) {
                            Text("Info!")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding()
                                .foregroundColor(.white)
                                .background(themeManager.isDarkMode ? Color.gray.opacity(0.4) : Color.teal)
                                .cornerRadius(10)
                        }

                        // Dark mode toggle button
                        Button(action: {
                            withAnimation {
                                themeManager.isDarkMode.toggle()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .strokeBorder(themeManager.isDarkMode ? Color.white : Color.gray, lineWidth: 3)
                                    .background(Circle().fill(themeManager.isDarkMode ? Color.gray : Color.white))
                                    .frame(width: 70, height: 70)
                                    .shadow(radius: 5)

                                Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(themeManager.isDarkMode ? .white : .yellow)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .sheet(isPresented: $isInfoSheetPresented) {
                InfoView()
                    .environmentObject(themeManager) // Pass ThemeManager to InfoView
            }
        }
    }
}

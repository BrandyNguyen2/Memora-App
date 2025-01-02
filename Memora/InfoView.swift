//
//  InfoView.swift
//  Memora
//
//  Created by Bryant Martinez on 12/8/24.
//  Updated by Bryant Martinez For Color And Dark Mode on 12/9/24

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager // Access global dark mode state

    var body: some View {
        NavigationView {
            ZStack {
                (themeManager.isDarkMode ? Color.black.opacity(0.8) : Color.white)
                    .ignoresSafeArea()

                VStack {
                    Text("Creators of Memora")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        .padding()


                    Text("This application was created by:")
                        .font(.title3)
                        .foregroundColor(themeManager.isDarkMode ? .gray : .gray.opacity(0.7))
                        .padding(.bottom)

                Text("Alexis, Angel, Brandy, Bryant, and Alec")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 20)


                    Text("We hope you enjoy using Memora to manage your flashcards and learn effectively!")
                        .font(.body)
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        .multilineTextAlignment(.center)
                        .padding()

                    Button(action: {
                        dismiss()
                    }) {
                        Text("Close")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding()
                .background(themeManager.isDarkMode ? Color.gray.opacity(0.2) : Color.white)
                .cornerRadius(20)
                .shadow(color: themeManager.isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.2), radius: 10)
            }
        }
    }
}

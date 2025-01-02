//
//  CreateAlbumView.swift
//  Memora
//
//  Created by Alexis Nemsingh on 12/8/24.
//  Updated by Bryant Martinez on 12/9/24

import SwiftUI

struct CreateAlbumView: View {
    @ObservedObject var manager: FlashcardManager
    @Environment(\.dismiss) private var dismiss
    @State private var albumTitle = ""
    @EnvironmentObject var themeManager: ThemeManager // Access global dark mode state
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color based on dark mode
                (themeManager.isDarkMode ? Color.black.opacity(0.8) : Color.white)
                    .ignoresSafeArea()
                
                VStack {
                    TextField("Enter Album Title", text: $albumTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(themeManager.isDarkMode ? Color.gray.opacity(0.8) : Color.white) // Background for the text field
                        .cornerRadius(10)
                        .foregroundColor(themeManager.isDarkMode ? .black : .black) // Text color
                        .shadow(radius: themeManager.isDarkMode ? 5 : 0)
                    
                    Button("Save Album") {
                        manager.addAlbum(title: albumTitle)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(themeManager.isDarkMode ? Color.black.opacity(0.2) : Color.blue.opacity(0.2))
                    .disabled(albumTitle.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Create Album")
            .foregroundColor(themeManager.isDarkMode ? .white : .blue) // "Create Album" text color based on dark mode
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.isDarkMode ? .white : .blue) // Toolbar button color
                }
            }
        }
    }
}

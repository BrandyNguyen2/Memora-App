//
//  FlashCardView.swift
//  Memora
//
//  Created by Alexis Nemsingh on 12/8/24.

//  Updated by Bryant Martinez, added Dark Mode on 12/9/24

import SwiftUI

struct FlashcardView: View {
    var flashcard: Flashcard
    @ObservedObject var manager: FlashcardManager
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    @EnvironmentObject var themeManager: ThemeManager // Access global dark mode state
    
    var body: some View {
        ZStack {
            // Background color based on dark mode
            (themeManager.isDarkMode ? Color.black.opacity(0.8) : Color.white)
                .ignoresSafeArea()
            
            VStack {
                if let frontImageData = flashcard.frontImage, let frontImage = UIImage(data: frontImageData) {
                    Image(uiImage: frontImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                }
                
                Text(flashcard.question)
                    .font(.headline)
                    .padding()
                    .foregroundColor(themeManager.isDarkMode ? .white : .black.opacity(0.8)) // Text color based on dark mode
                
                if let backImageData = flashcard.backImage, let backImage = UIImage(data: backImageData) {
                    Image(uiImage: backImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                }
                
                Text(flashcard.answer)
                    .font(.subheadline)
                    .padding()
                    .foregroundColor(themeManager.isDarkMode ? .white : .black.opacity(0.8)) // Text color based on dark mode
                
                Spacer()
                
                Button(action: {
                    showAlert = true
                }) {
                    Text("Delete Flashcard")
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Delete Flashcard"),
                        message: Text("Are you sure you want to delete this flashcard?"),
                        primaryButton: .destructive(Text("Delete")) {
                            manager.deleteFlashcard(flashcard)
                            dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Flashcard")
        .navigationBarTitleDisplayMode(.inline)
        .foregroundColor(themeManager.isDarkMode ? .blue : .blue) // Title text color based on dark mode
    }
}

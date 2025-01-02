//
//  CreateFlashcardView.swift
//  Memora
//
//  Created by Alexis Nemsingh on 12/8/24.
//  Updated by Bryant Martinez, added Dark Mode on 12/9/24

import SwiftUI
import PhotosUI

struct CreateFlashcardView: View {
    @ObservedObject var manager: FlashcardManager
    var albumId: UUID
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager // Access global dark mode state
    
    @State private var frontText = ""
    @State private var backText = ""
    @State private var frontImage: UIImage?
    @State private var backImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isFrontSide = true
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color based on dark mode
                (themeManager.isDarkMode ? Color.black.opacity(0.8) : Color.white)
                    .ignoresSafeArea()
                
                VStack {
                    if isFrontSide {
                        // Front of Card View
                        VStack {
                            if let image = frontImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(10)
                            }
                            
                            TextField("Enter Text", text: $frontText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .background(themeManager.isDarkMode ? Color.gray : Color.white) // TextField background color
                                .cornerRadius(10)
                                .foregroundColor(themeManager.isDarkMode ? .black : .black) // Text color
                                .shadow(radius: themeManager.isDarkMode ? 5 : 0)
                        }
                        
                        Button("Next") {
                            isFrontSide = false
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(frontText.isEmpty)
                    } else {
                        // Back of Card View
                        VStack {
                            if let image = backImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(10)
                            }
                            
                            TextField("Enter Text", text: $backText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .background(themeManager.isDarkMode ? .gray : .black) // TextField background color
                                .cornerRadius(10)
                                .foregroundColor(themeManager.isDarkMode ? .black : .blue) // Text color
                                .shadow(radius: themeManager.isDarkMode ? 5 : 0)
                        }
                        
                        Button("Save Flashcard") {
                            let frontImageData = frontImage?.jpegData(compressionQuality: 0.8)
                            let backImageData = backImage?.jpegData(compressionQuality: 0.8)
                            manager.addFlashcard(to: albumId, question: frontText, answer: backText, frontImage: frontImageData, backImage: backImageData)
                            print(manager.albums[0].flashcards)
                            print("card saved")
                            
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
            }
            .navigationTitle(isFrontSide ? "Front of Card" : "Back of Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.isDarkMode ? .white : .blue) // Toolbar button color
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Take Photo") {
                            sourceType = .camera
                            isImagePickerPresented = true
                        }
                        
                        Button("Choose from Library") {
                            sourceType = .photoLibrary
                            isImagePickerPresented = true
                        }
                    } label: {
                        Label("Add Image", systemImage: "camera.fill")
                            .foregroundColor(themeManager.isDarkMode ? .white : .blue) // Menu item color
                    }
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: isFrontSide ? $frontImage : $backImage, sourceType: sourceType)
            }
        }
    }
}

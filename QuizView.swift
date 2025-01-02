//
//  AlbumView.swift
//  Memora
//
//  Created by Angel Lyn Cervantes on 12/7/24.
//  Updated by Bryant Martinez, added Darkmode on 12/9/24

import SwiftUI

struct AlbumView: View {
    @State private var isAddCardSheetPresented = false
    @State private var showQuizAlert = false
    @State private var showDeleteAlert = false
    @State private var isQuizActivated = false
    @ObservedObject var manager: FlashcardManager
    var albumId: UUID
    @EnvironmentObject var themeManager: ThemeManager // Use the custom theme manager

    var body: some View {
        VStack {
            Text("Viewing Album")
                .font(.largeTitle)
                .padding(.top, 50)
                .foregroundColor(themeManager.isDarkMode ? .white : .black) // Use themeManager for dark mode
            
            Spacer()
            
            Button(action: {
                isAddCardSheetPresented = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(themeManager.isDarkMode ? .white : .blue) // Button color based on theme
            }
            
            Text("Add Flashcards")
                .font(.title2)
                .padding(.top, 10)
                .foregroundColor(themeManager.isDarkMode ? .white : .black) // Text color for light/dark mode
            
            List {
                ForEach(manager.albums.first { $0.id == albumId }?.flashcards ?? []) { flashcard in
                    NavigationLink(destination: FlashcardView(flashcard: flashcard, manager: manager)) {
                        VStack(alignment: .leading) {
                            Text(flashcard.question)
                                .font(.headline)
                                .foregroundColor(themeManager.isDarkMode ? .black : .blue) // Question text color
                            Text(flashcard.answer)
                                .font(.subheadline)
                                .foregroundColor(themeManager.isDarkMode ? .black : .blue) // Answer text color
                        }
                    }
                }
            }
            .background(themeManager.isDarkMode ? Color.black.opacity(0.8) : Color.white) // List background color
            .listRowBackground(themeManager.isDarkMode ? Color.gray.opacity(0.4) : Color.white) // List row background color
            
            Spacer()
            
            HStack {
                Spacer()
                
                // Quiz Me! Button
                if let flashcards = manager.albums.first(where: { $0.id == albumId })?.flashcards, flashcards.count > 0 {
                    NavigationLink(
                        "Quiz Me!",
                        destination: QuizView(
                            manager: manager,
                            albumId: albumId,
                            cardId: 0,
                            count: flashcards.count
                        )
                    )
                } else {
                    Button(action: {
                        showQuizAlert = true
                    }) {
                        Text("Quiz Me")
                            .foregroundColor(themeManager.isDarkMode ? .white : .black) // Button text color
                    }
                    .alert(isPresented: $showQuizAlert) {
                        Alert(
                            title: Text("No Flashcards"),
                            message: Text("You cannot run a quiz. There are no flashcards in this album.")
                        )
                    }
                }
                
                Spacer()

                // Start Timer Review Button
                if let flashcards = manager.albums.first(where: { $0.id == albumId })?.flashcards, flashcards.count > 0 {
                    NavigationLink(
                        "Start Timer Review",
                        destination: FlashcardReviewView(manager: manager, albumId: albumId)
                    )
                } else {
                    Button(action: {
                        showQuizAlert = true
                    }) {
                        Text("Start Timer Review")
                            .foregroundColor(themeManager.isDarkMode ? .white : .black) // Button text color
                    }
                    .alert(isPresented: $showQuizAlert) {
                        Alert(
                            title: Text("No Flashcards"),
                            message: Text("You cannot start the timer review. There are no flashcards in this album.")
                        )
                    }
                }

                Spacer()
                
                // Delete Album Button
                Button(action: {
                    showDeleteAlert = true
                }) {
                    Text("Delete Album")
                        .foregroundColor(.red) // Delete button is always red
                }
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("Delete Album"),
                        message: Text("Are you sure you want to delete this album?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let album = manager.albums.first(where: { $0.id == albumId }) {
                                manager.deleteAlbum(album)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                Spacer()
            }
        }
        .padding()
        .background(themeManager.isDarkMode ? Color.black.opacity(0.8): Color.white) // Overall background color
        .foregroundColor(themeManager.isDarkMode ? .white : .black) // Default text color based on theme
        .sheet(isPresented: $isAddCardSheetPresented) {
            CreateFlashcardView(manager: manager, albumId: albumId)
        }
        .sheet(isPresented: $isQuizActivated) {
            if (manager.albums.first { $0.id == albumId }?.flashcards.count ?? 0 ) > 0 {
                // Add the logic for quiz sheet if needed
            }
        }
    }
}

//
//  Timer.swift
//  Memora
//
//  Created by Brandy Nguyen on 12/9/24.
//  Updated by Bryant Martinez For Color And Dark Mode on 12/9/24
import SwiftUI

struct FlashcardReviewView: View {
    @ObservedObject var manager: FlashcardManager
    var albumId: UUID
    @EnvironmentObject var themeManager: ThemeManager // Use the custom theme manager for dark mode
    
    // Timer-related state variables
    @State private var selectedTimerDuration: Double = 30 // Default 30 seconds
    @State private var timeRemaining: Double = 30
    @State private var isTimerRunning = false
    @State private var showTimerSetup = true
    
    // Flashcard review states
    @State private var currentCardIndex = 0
    @State private var isCardFlipped = false
    
    // Timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var currentFlashcards: [Flashcard] {
        manager.albums.first(where: { $0.id == albumId })?.flashcards ?? []
    }
    
    var body: some View {
        VStack {
            if showTimerSetup {
                // Timer Setup View
                timerSetupView
            } else {
                // Review View
                reviewView
            }
        }
        .navigationTitle("Flashcard Review")
        .onReceive(timer) { _ in
            if isTimerRunning {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    // Timer finished
                    isTimerRunning = false
                    showTimerSetup = true
                }
            }
        }
        .background(themeManager.isDarkMode ? Color.black : Color.white) // Background color based on theme
        .foregroundColor(themeManager.isDarkMode ? .white : .black) // Text color based on theme
    }
    
    var timerSetupView: some View {
        VStack {
            Text("Set Review Timer")
                .font(.title2)
                .padding()
                .foregroundColor(themeManager.isDarkMode ? .white : .black) // Text color based on theme
            
            // Timer duration slider
            Text("Timer Duration: \(Int(selectedTimerDuration)) seconds")
                .foregroundColor(themeManager.isDarkMode ? .white : .black) // Text color based on theme
            
            Slider(value: $selectedTimerDuration,
                   in: 10...300, // 10 seconds to 5 minutes
                   step: 5)
                .padding()
            
            Button("Start Review") {
                timeRemaining = selectedTimerDuration
                isTimerRunning = true
                showTimerSetup = false
                currentCardIndex = 0
            }
            .buttonStyle(.borderedProminent)
            .disabled(currentFlashcards.isEmpty)
        }
        .padding()
        .background(themeManager.isDarkMode ? Color.gray.opacity(0.3) : Color.white) // Background color based on theme
        .cornerRadius(10)
    }
    
    var reviewView: some View {
        VStack {
            // Timer Display
            Text("\(Int(timeRemaining)) seconds remaining")
                .font(.headline)
                .padding()
                .foregroundColor(themeManager.isDarkMode ? .white : .black) // Text color based on theme
            
            // Progress Indicator
            Text("Card \(currentCardIndex + 1) of \(currentFlashcards.count)")
                .foregroundColor(themeManager.isDarkMode ? .gray : .secondary) // Progress text color
            
            // Flashcard View
            if !currentFlashcards.isEmpty {
                let currentCard = currentFlashcards[currentCardIndex]
                
                GeometryReader { geometry in
                    VStack {
                        // Front of Card
                        if !isCardFlipped {
                            Text(currentCard.question)
                                .font(.title)
                                .padding()
                                .frame(width: geometry.size.width * 0.9) // Make card width 90% of the available space
                                .foregroundColor(themeManager.isDarkMode ? .white : .black) // Text color based on theme
                        }
                        // Back of Card
                        else {
                            Text(currentCard.answer)
                                .font(.title)
                                .padding()
                                .frame(width: geometry.size.width * 0.9)
                                .foregroundColor(themeManager.isDarkMode ? .white : .black) // Text color based on theme
                        }
                        
                        // Card Image (if exists)
                        if let imageData = isCardFlipped ? currentCard.backImage : currentCard.frontImage,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.9, height: 200)
                                .cornerRadius(10)
                        }
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .padding()
                    .background(themeManager.isDarkMode ? Color.gray.opacity(0.3) : Color.white) // Card background based on theme
                    .cornerRadius(15)
                    .onTapGesture {
                        withAnimation {
                            isCardFlipped.toggle()
                        }
                    }
                }
                .frame(height: 350) // Set a height for the GeometryReader
                .padding()
                
                // Navigation Buttons
                HStack {
                    Button("Previous") {
                        if currentCardIndex > 0 {
                            currentCardIndex -= 1
                            isCardFlipped = false
                        }
                    }
                    .disabled(currentCardIndex == 0)
                    .foregroundColor(themeManager.isDarkMode ? .white : .blue) // Button color based on theme
                    
                    Button("Next") {
                        if currentCardIndex < currentFlashcards.count - 1 {
                            currentCardIndex += 1
                            isCardFlipped = false
                        }
                    }
                    .disabled(currentCardIndex == currentFlashcards.count - 1)
                    .foregroundColor(themeManager.isDarkMode ? .white : .blue) // Button color based on theme
                }
                .padding()
            } else {
                Text("No flashcards in this album")
                    .foregroundColor(themeManager.isDarkMode ? .white : .black) // Text color based on theme
            }
            
            // End Review Button
            Button("End Review") {
                showTimerSetup = true
                isTimerRunning = false
            }
            .foregroundColor(.red)
        }
        .padding()
    }
}


//
//  ContentView.swift
//  Memora
//
//  Updated by Bryant Martinez For Color And Dark Mode on 12/9/24
import SwiftUI

struct ContentView: View {
    @State private var isAddAlbumSheetPresented = false
    @StateObject private var manager = FlashcardManager()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            ZStack {
                (themeManager.isDarkMode ? Color.black.opacity(0.8) : Color.white)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Memora")
                        .font(.largeTitle)
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    VStack {
                        Spacer()
                        
                        VStack {
                            Button(action: {
                                isAddAlbumSheetPresented = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(themeManager
                                        .isDarkMode ? .white : .blue)
                            }
                            Text("Create Flashcard Set")
                                .font(.title3)
                                .foregroundColor(themeManager.isDarkMode ? .white : .black.opacity(0.8))
                                .padding(.top, 10)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    List {
                        ForEach(manager.albums) { album in
                            NavigationLink(destination: AlbumView(manager: manager, albumId: album.id)) {
                                HStack {
                                    Text(album.title)
                                        .foregroundColor(themeManager.isDarkMode ? .white : .black.opacity(0.8))
                                    Spacer()
                                }
                            }
                        }
                        .listRowBackground(themeManager.isDarkMode ? Color.gray.opacity(0.4) : Color.white)
                    }
                    .scrollContentBackground(.hidden)
                    .background(themeManager.isDarkMode ? Color.black.opacity(0.8) : Color.white)
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $isAddAlbumSheetPresented) {
                CreateAlbumView(manager: manager)
                    .environmentObject(themeManager)
            }
        }
    }
}

#Preview {
    LandingPageView()
        .environmentObject(ThemeManager())
}

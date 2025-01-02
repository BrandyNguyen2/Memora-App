//
//  FlashCardManager.swift
//  Memora
//
//  Created by Angel Lyn Cervantes on 12/7/24.
//

import Foundation

class FlashcardManager: ObservableObject {
    @Published var albums: [Album] = [] {
        didSet {
            saveAlbums()
        }
    }
    
    private let albumsKey = "albums_key"
    
    init() {
        loadAlbums()
    }
    
    func saveAlbums() {
        if let encodedData = try? JSONEncoder().encode(albums) {
            UserDefaults.standard.set(encodedData, forKey: albumsKey)
        }
    }
    
    func loadAlbums() {
        if let savedData = UserDefaults.standard.data(forKey: albumsKey),
           let decodedAlbums = try? JSONDecoder().decode([Album].self, from: savedData) {
            self.albums = decodedAlbums
        }
    }
    
    func addAlbum(title: String) {
        let newAlbum = Album(title: title, flashcards: [])
        albums.append(newAlbum)
    }
    
    func addFlashcard(to albumId: UUID, question: String, answer: String, frontImage: Data?, backImage: Data?) {
        if let index = albums.firstIndex(where: { $0.id == albumId }) {
            let newFlashcard = Flashcard(question: question, answer: answer, frontImage: frontImage, backImage: backImage)
            albums[index].flashcards.append(newFlashcard)
        }
    }
    
    func deleteAlbum(_ album: Album) {
        if let index = albums.firstIndex(where: { $0.id == album.id }) {
            albums.remove(at: index)
        }
    }
    
    func deleteFlashcard(_ flashcard: Flashcard) {
        for (albumIndex, album) in albums.enumerated() {
            if let flashcardIndex = album.flashcards.firstIndex(where: { $0.id == flashcard.id }) {
                albums[albumIndex].flashcards.remove(at: flashcardIndex)
                break
            }
        }
    }
}

//
//  DataStructures.swift
//  Memora
//
//  Created by Angel Lyn Cervantes on 12/7/24.
//
import Foundation

struct Flashcard: Identifiable, Codable {
    var id = UUID()
    var question: String
    var answer: String
    var frontImage: Data?
    var backImage: Data?
}

struct Album: Identifiable, Codable {
    var id = UUID()
    var title: String
    var flashcards: [Flashcard]
}

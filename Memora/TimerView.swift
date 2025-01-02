//
//  TimerView.swift
//  Memora
//
//  Created by Brandy Nguyen on 12/9/24.
//

import SwiftUI
import UIKit

struct FlashcardReviewView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = FlashcardManager()
        let album = Album(
            id: UUID(),
            title: "Sample Album",
            flashcards: [
                Flashcard(question: "What is SwiftUI?", answer: "A UI framework by Apple")
            ]
        )
        manager.albums.append(album)
        return NavigationView {
            FlashcardReviewView(manager: manager, albumId: album.id)
        }
    }
}


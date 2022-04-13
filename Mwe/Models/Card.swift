//
//  Card.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 4/12/22.
//

import Foundation

enum CardType {
    case Placeholder
    case Image
}

struct Card: Identifiable, Equatable {
    let type: CardType
    let imageUrl: String?
    let id = UUID()
}

class CardDeck: ObservableObject {
    @Published var cards: [Card]
    
    init(){
        cards = []
    }
    
    func indexOfCard(_ card: Card) -> Double {
        if let index = cards.firstIndex(of: card){
            return Double(index)
        } else {
            return 0.0
        }
    }
    
    func select(_ card: Card){
        if let index = cards.firstIndex(of: card), index >= 0 && index < cards.count {
            let card = self.cards.remove(at: index)
            self.cards.insert(card, at: 0)
        }
    }
}

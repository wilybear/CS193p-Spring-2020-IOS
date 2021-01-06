//
//  MemoryGame.swift
//  Memorize
//
//  Created by 김현식 on 2021/01/02.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    //mutating,, all init is mutating
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int)->CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards{
            let content = cardContentFactory(pairIndex)
            //let content : Cardcontent ->>> inferring type
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    // all functions modify self have to be marked 'mutating' in struct, x class
    mutating func choose(card: Card){
        print("card choosen: \(card)")
        let chosenIndex: Int = self.index(of: card)
        self.cards[chosenIndex].isFaceUp = !self.cards[chosenIndex].isFaceUp
    }
    
    func index(of card: Card) -> Int{
        for index in 0..<self.cards.count{
            if self.cards[index].id == card.id{
                return index
            }
        }
        return 0 // TODO : bogus!
    }
    
    //MemoryGame.Card
    struct Card : Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent //dont care type
        var id: Int
    }
}

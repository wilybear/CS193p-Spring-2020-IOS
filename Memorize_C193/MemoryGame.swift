//
//  MemoryGame.swift
//  Memorize
//
//  Created by 김현식 on 2021/01/02.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int)->CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards{
            let content = cardContentFactory(pairIndex)
            //let content : Cardcontent ->>> inferring type
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
    }
    
    func choose(card: Card){
        print("card choosen: \(card)")
    }
    
    //MemoryGame.Card
    struct Card : Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent //dont care type
        var id: Int
    }
}

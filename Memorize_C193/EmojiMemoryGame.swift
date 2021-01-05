//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 김현식 on 2021/01/02.
//

import SwiftUI

//func createCardContent(pairIndex: Int)->String{
//    return "😀"
//}
//no need to create extra function -> inline the code (closure)

class EmojiMemoryGame{
    
    private var model: MemoryGame<String>  = EmojiMemoryGame.createMemoryGame()
    //private(set) means only EmojiMemoryGame can modify model, but every view can see it
    	
    //if you put static it means function on the type(EmojiMemoryGame), x function on instance of class
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["🎃","👻","👾","🥵","👹","🤖","🥶","😱"].shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 2...5)) { pairIndx in
            return emojis[pairIndx]
        }    //_  means unused in swift
    }

    
    
    // MARK: - Access to the model
    var cards: Array<MemoryGame<String>.Card>{
        model.cards
    }
    //maybe interpretation (massage data into some form / might work data network request)
    
    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card){
        model.choose(card: card)
    }
    
}


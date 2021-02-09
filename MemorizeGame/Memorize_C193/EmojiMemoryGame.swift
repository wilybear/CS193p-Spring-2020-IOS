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


//ObeservableObject only works for class
class EmojiMemoryGame : ObservableObject{
    
    //property wrapper, evert tune modle changes it calls objectwillchange()
    @Published private var model: MemoryGame<String>
    //private(set) means only EmojiMemoryGame can modify model, but every view can see it
    var theme: Theme
    
    init(theme: Theme) {
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    	
    //if you put static it means function on the type(EmojiMemoryGame), x function on instance of class
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let emojis: Array<String> = theme.emojis.shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfCards) { pairIndex in
            return emojis[pairIndex]
        }    //_  means unused in swift
    }

    // var objectWillChange: ObservableObjectPublisher gives free
    
    // MARK: - Access to the model
    var cards: Array<MemoryGame<String>.Card>{
        model.cards
    }
    
    var score: Int{
        model.score
    }
    //maybe interpretation (massage data into some form / might work data network request)
    
    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card){
    //    objectWillChange.send()
        model.choose(card: card)
    }
    
    func startNewGame(){
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
}


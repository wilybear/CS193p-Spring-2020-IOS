//
//  MemoryGame.swift
//  Memorize
//
//  Created by 김현식 on 2021/01/02.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    var cards: Array<Card>
    var theme: Theme
    var score: Int = 0
    var openedCard: [CardContent] = [CardContent]()
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter {cards[$0].isFaceUp }.only//array of int
        }
        set{
            for index in cards.indices{
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    //mutating,, all init is mutating
    init(numberOfPairsOfCards: Int,theme : Theme ,cardContentFactory: (Int)->CardContent) {
        cards = Array<Card>()
        self.theme = theme
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
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched{    //,(comma) means sequential AND
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard{
                if cards[chosenIndex].content == cards[potentialMatchIndex].content{
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                }else{
                    if openedCard.firstIndex(of: cards[chosenIndex].content) == nil {
                        openedCard.append(cards[chosenIndex].content)
                    }
                    else{
                        score -= 1
                    }
                    if openedCard.firstIndex(of: cards[potentialMatchIndex].content) == nil {
                        openedCard.append(cards[potentialMatchIndex].content)
                    }
                    else{
                        score -= 1
                    }
                }
                self.cards[chosenIndex].isFaceUp = true
            }else{
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
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
    struct Card : Identifiable{
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent //dont care type
        var id: Int
    }
}

enum Theme : CaseIterable{
    case halloween, sport, animal, face

    static func getRandomCase()->Theme{
        allCases.randomElement()!
    }
    func getEmojiArray()->[String]{
        switch self {
            case .halloween:
                return ["🎃","👻","👾","🥵","👹","🤖","🥶","😱"]
            case .animal:
                return ["🐶","🐱","🐭","🐹","🐼","🐮","🐷"]
            case .face:
                return ["😀","🤪","😛","😇","☺️","😌","🥰","😎"]
            case .sport:
                return ["⚽️","🏀","🏈","⚾️","🏓","⛳️","🏏"]
        }
    }
    
    func getEmojiName()->String{
        switch self {
           case .halloween:
               return "halloween"
           case .animal:
               return "animal"
           case .face:
               return "face"
           case .sport:
               return "sport"
        }
    }
}


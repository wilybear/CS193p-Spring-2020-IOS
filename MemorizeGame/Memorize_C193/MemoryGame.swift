//
//  MemoryGame.swift
//  Memorize
//
//  Created by 김현식 on 2021/01/02.
//

import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score: Int = 0
    private var openedCard: [CardContent] = [CardContent]()
    private var lastMatchedDate : Date
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
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
    init(numberOfPairsOfCards: Int,cardContentFactory: (Int)->CardContent) {
        cards = Array<Card>()
        lastMatchedDate = Date()
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
                    //Extra Credit, giving more points for choosing cards more quickly
                    score += max(10+Int(lastMatchedDate.timeIntervalSince(Date())),1)*2
                    lastMatchedDate = Date()
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
        var isFaceUp: Bool = false{
            didSet{
                if isFaceUp {
                    startUsingBonusTime()
                }else{
                    stopUsingBonusTime()
                }
            }
        }
        
        var isMatched: Bool = false{
            didSet{
                stopUsingBonusTime()
            }
        }
        var content: CardContent //dont care type
        var id: Int
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certaion maount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = lastFaceUpDate{
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has benn face up in the past
        // (i.e not including the current time it's benn face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining : TimeInterval{
            max(0,bonusTimeLimit - faceUpTime)
        }
        
        // percentage of the bonus time remaining
        var bonusRemaining: Double{
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool{
            isMatched && bonusTimeRemaining > 0
        }
        
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isComsumingBonusTime: Bool{
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime(){
            if isComsumingBonusTime, lastFaceUpDate == nil{
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime(){
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
    }
    
}




//
//  ContentView.swift
//  Memorize
//
//  Created by 김현식 on 2021/01/01.
//

import SwiftUI

struct ContentView: View {
    var viewModel: EmojiMemoryGame
        
    var body: some View {
        //horizontal stack
       HStack{
        ForEach(viewModel.cards) { card in
            CardView(card: card)
            //sily question return CardView doesn't genreate error
            }
        }
            .foregroundColor(Color.orange)
            .padding()
            .font(Font.largeTitle)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}

struct CardView: View{
    var card : MemoryGame<String>.Card
    var body: some View{
        ZStack{
            if card.isFaceUp{
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
    }
}

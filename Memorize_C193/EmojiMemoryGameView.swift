//
//  ContentView.swift
//  Memorize
//
//  Created by 김현식 on 2021/01/01.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    //this var has obeservedObject, it says objectwillchange and redraw UI
    //redraw not whole thing but changed one by identifier
    @ObservedObject var viewModel: EmojiMemoryGame
    private var themeColor : (Color,Color) {
        get{
            switch viewModel.theme {
            case .halloween:
                return (.orange,.green)
            case .animal:
                return (.green,.gray)
            case .sport:
                return (.blue,.orange)
            case .face:
                return (.yellow,.pink)
            }
        }
    }
    
        
    var body: some View {
        VStack{
        //horizontal stack
            HStack(alignment: .center, spacing: 10){
                Button("NewGame"){
                    viewModel.startNewGame()
                }.padding()
                Spacer()
                Text(String(viewModel.score))
                Spacer()
                Text(viewModel.theme.getEmojiName())
                    .padding()
            }
            .font(Font.title2)
            .frame(height:50)

            Grid(viewModel.cards) { card in
                CardView(card: card, colorTuple : themeColor).onTapGesture {
                    viewModel.choose(card: card)
                }
                .aspectRatio(0.66, contentMode: .fit)
                .padding()
                //sily question return CardView doesn't genreate error
            }
            .foregroundColor(themeColor.0)
        }
    }
}


struct CardView: View{
    var card : MemoryGame<String>.Card
    var colorTuple : (Color, Color)
    var body: some View{
        GeometryReader{ geometry in
            //@Viewbuilder, if it is function
            if card.isFaceUp || !card.isMatched{
                ZStack{
                    Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90),clockwise: true).padding(5).opacity(0.4)
                    Text(card.content)
                        .font(Font.system(size: fontSize(for: geometry.size)))
                }
                .cardify(isFaceUp: card.isFaceUp)
            }
        }
    }
    
    //func body(for size:CGSize) -> some View{ ... }
    
    // MARK: - Drawing Constants
    private func fontSize(for size: CGSize) -> CGFloat{
        min(size.width, size.height) * 0.7
    }
   
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[2])
        return EmojiMemoryGameView(viewModel: game)
    }
}

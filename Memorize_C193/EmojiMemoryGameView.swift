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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}

struct CardView: View{
    var card : MemoryGame<String>.Card
    var colorTuple : (Color, Color)
    var body: some View{
        GeometryReader{ geometry in
            ZStack{
                if card.isFaceUp{
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                    Text(card.content)
                } else {
                    if !card.isMatched{
                        //Extra credit, gradient color
                        RoundedRectangle(cornerRadius: cornerRadius).fill(
                            LinearGradient(gradient: Gradient(colors: [colorTuple.0, colorTuple.1]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                        )
                    }
                }
            }
            .font(Font.system(size: fontSize(for: geometry.size)))
        }
    }
    
    //func body(for size:CGSize) -> some View{ ... }
    
    // MARK: - Drawing Constants
    
    private let cornerRadius:CGFloat = 10
    private let edgeLineWidth:CGFloat = 3
    private func fontSize(for size: CGSize) -> CGFloat{
        min(size.width, size.height) * 0.75
    }
    
}

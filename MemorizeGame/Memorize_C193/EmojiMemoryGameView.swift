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
        
    var body: some View {
        VStack{
        //horizontal stack
            HStack(alignment: .center, spacing: 10){
                Button(action: {
                    withAnimation(.easeInOut(duration:2)){
                        viewModel.startNewGame()
                    }
                }, label: { Text("New Game")})  //see documents about localizedString key
                Spacer()
                Text(String(viewModel.score))
            }
            .font(Font.title3)
            .padding()

            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.75)){
                        viewModel.choose(card: card)
                    }
                }
                .padding()
                //sily question return CardView doesn't genreate error
            }
            .foregroundColor(Color(viewModel.theme.color))
        }
    }
}


struct CardView: View{
    var card : MemoryGame<String>.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation(){
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)){
            animatedBonusRemaining = 0
        }
    }
    
    var body: some View{
        GeometryReader{ geometry in
            //@Viewbuilder, if it is function
            if card.isFaceUp || !card.isMatched{
                ZStack{
                    if card.isComsumingBonusTime{
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90),clockwise:true)
                            .padding(5).opacity(0.4)
                            .onAppear(){
                                startBonusTimeAnimation()
                            }
                    }else{
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90),clockwise:true)
                            .padding(5).opacity(0.4)
                    }
                    Text(card.content)
                        .font(Font.system(size: fontSize(for: geometry.size)))
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(card.isMatched ? Animation.linear.repeatForever(autoreverses: false) : .default)
                }
                .cardify(isFaceUp: card.isFaceUp)
                .transition(AnyTransition.scale)
            }
        }
    }
    
    //func body(for size:CGSize) -> some View{ ... }
    
    // MARK: - Drawing Constants
    private func fontSize(for size: CGSize) -> CGFloat{
        min(size.width, size.height) * 0.7
    }
   
}




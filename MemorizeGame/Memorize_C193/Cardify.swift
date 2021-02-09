//
//  Cardify.swift
//  Memorize_C193
//
//  Created by 김현식 on 2021/01/17.
//

import SwiftUI

struct Cardify : AnimatableModifier {   //Animatable ,Viewmodifier
    var rotation: Double
    var isFaceUp: Bool {
        rotation < 90
    }
    init(isFaceUp:Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get{ return rotation }
        set{ rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack{
            Group{
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
                .opacity(isFaceUp ? 1 : 0)
            //Extra credit, gradient color
            RoundedRectangle(cornerRadius: cornerRadius).fill(
              //  LinearGradient(gradient: Gradient(colors: [colorTuple.0, colorTuple.1]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
            )
                .opacity(isFaceUp ? 0 : 1)
            
        }
        .rotation3DEffect(Angle.degrees(rotation), axis:(0,1,0))

    }
    
    private let cornerRadius:CGFloat = 10
    private let edgeLineWidth:CGFloat = 3

}

extension View{
    func cardify(isFaceUp:Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}

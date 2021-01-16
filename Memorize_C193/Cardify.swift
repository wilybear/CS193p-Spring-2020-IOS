//
//  Cardify.swift
//  Memorize_C193
//
//  Created by 김현식 on 2021/01/17.
//

import SwiftUI

struct Cardify : ViewModifier {
    var isFaceUp:Bool
    
    func body(content: Content) -> some View {
        ZStack{
            if isFaceUp{
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            } else {
                //Extra credit, gradient color
                RoundedRectangle(cornerRadius: cornerRadius).fill(
                  //  LinearGradient(gradient: Gradient(colors: [colorTuple.0, colorTuple.1]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                )
            }
        }
    }
    
    private let cornerRadius:CGFloat = 10
    private let edgeLineWidth:CGFloat = 3

}

extension View{
    func cardify(isFaceUp:Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}

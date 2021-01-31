//
//  PalleteChooser.swift
//  EmojiArt
//
//  Created by 김현식 on 2021/01/31.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    @Binding var chosenPallete: String
    
    var body: some View {
        HStack{
            Stepper(
                onIncrement: {
                    chosenPallete = document.palette(after: chosenPallete)
                },
                onDecrement: {
                    chosenPallete = document.palette(before: chosenPallete)
                },
                label: {
                    EmptyView()
                })
            Text(document.paletteNames[chosenPallete] ?? "")
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct PalleteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(),chosenPallete: Binding.constant(""))
    }
}


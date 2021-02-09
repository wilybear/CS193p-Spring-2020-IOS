//
//  PalleteChooser.swift
//  EmojiArt
//
//  Created by 김현식 on 2021/01/31.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    @Binding var chosenPalette: String
    @State private var showPaletteEditor = false
    
    var body: some View {
        HStack{
            Stepper(
                onIncrement: {
                    chosenPalette = document.palette(after: chosenPalette)
                },
                onDecrement: {
                    chosenPalette = document.palette(before: chosenPalette)
                },
                label: {
                    EmptyView()
                })
            Text(document.paletteNames[chosenPalette] ?? "")
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture {
                    showPaletteEditor = true
                }
                //.popover
                .sheet(isPresented: $showPaletteEditor){
                    PaletteEditor(chosenPalette: $chosenPalette, isShowing: $showPaletteEditor)
                        .environmentObject(document)
                        .frame(minWidth:300,minHeight: 500)
                }   // Dismissing popover content when clicked outside is default
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct PalleteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(),chosenPalette: Binding.constant(""))
    }
}


struct PaletteEditor:View{
    @Binding var chosenPalette: String
    @EnvironmentObject var document : EmojiArtDocument
    @State private var paletteName: String = ""
    @State private var emojisToAdd: String = ""
    @Binding var isShowing: Bool
    

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        VStack(spacing: 0){
            ZStack{
                Text("Palette Editor").font(.headline).padding()
                HStack{
                    Spacer()
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                    },label:{Text("Done")}).padding()
                }
            }
            Divider()
            Form{
                Section{
                    TextField("Palette Name", text: $paletteName, onEditingChanged:{ began in
                        if !began{
                            document.renamePalette(chosenPalette, to: paletteName)
                        }
                    })
                    TextField("AddEmoji", text: $emojisToAdd, onEditingChanged:{ began in
                        if !began{
                            chosenPalette = document.addEmoji(emojisToAdd, toPalette: chosenPalette)
                            emojisToAdd = ""
                        }
                    })
                }
                Section(header: Text("Remove Emoji")){
                    Grid(chosenPalette.map{String($0)}, id: \.self){ emoji in
                        Text(emoji)
                            .font(Font.system(size: fontSize))
                            .onTapGesture {
                                chosenPalette = document.removeEmoji(emoji, fromPalette: chosenPalette)
                            }
                    }
                    .frame(height: height)
                    
                }
            }
        }
        .onAppear{
            paletteName = document.paletteNames[chosenPalette] ?? ""
        }
    }
    
    var height: CGFloat {
        CGFloat((chosenPalette.count-1)/6) * 70 + 70
    }
    let fontSize : CGFloat = 40
}

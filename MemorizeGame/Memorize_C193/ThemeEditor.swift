//
//  ThemeEditor.swift
//  Memorize_C193
//
//  Created by 김현식 on 2021/02/05.
//

import SwiftUI
import Combine

struct ThemeEditor: View{
    
    @Binding var theme: Theme?{
        didSet{
            numbersOfPair = theme!.numberOfCards
        }
    }
    @Environment(\.presentationMode) var presentationMode
    @State private var themeName: String = ""
    @State private var emoji: String = ""
    @EnvironmentObject var store : ThemeStore
    @State private var numbersOfPair: Int = 0
    @State private var editorAlert: Bool = false
    
    @State private var errorMsg: String = ""
    @State private var themeColor: Color = Color.red
    
    var body: some View{
        VStack{
            HStack{
                //for alignments
                Text("Done").layoutPriority(1).padding().opacity(0)
                Spacer()
                Text(theme!.name)
                    .font(.system(size: 30,weight: .heavy, design: .default))
                    .layoutPriority(2)
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {Text("Done")}).padding()
                .layoutPriority(1)
            }
            Form{
                Section{
                    TextField(theme?.name ?? "Theme Name", text: $themeName, onCommit: {
                        theme = store.renameTheme(theme!, newName: themeName)
                    })
                }
                Section(header: Text("Add emojis")){
                    HStack{
                        TextField("emoji", text: $emoji)
                            .onReceive(Just(emoji)){_ in
                                limitText(1)
                            }
                        Button(action: {
                            if emoji != ""{
                                if let newTheme = store.addEmojis(theme!, emoji: emoji){
                                    theme = newTheme
                                    emoji = ""
                                }else{
                                    editorAlert = true
                                    errorMsg = "Current Emojis is already exist"
                                }
                            }
                        }, label: {
                            Text("Add")
                        })
                    }
                }
                Section(header:
                            HStack{ Text("Emojis")
                                Spacer()
                                Text("tap to exclude emoji").font(.caption2) }){
                    Grid(theme!.emojis.map{String($0)}, id: \.self){
                        emoji in
                        Text(emoji)
                            .font(Font.system(size: 30))
                            .onTapGesture {
                                if let newTheme = store.removeEmoji(theme!, emoji: emoji){
                                    theme = newTheme
                                }else{
                                    editorAlert = true
                                    errorMsg = "Emojis should be more than 2"
                                }
                            }
                        
                    }
                    .frame(height: height)
                }
                Section(header:Text("Card Count")){
                    Stepper("\(numbersOfPair) pairs",value: $numbersOfPair,in: 2...theme!.emojis.count)
                                                .onReceive(Just(numbersOfPair)) { value in
                                                    guard numbersOfPair > 0 else {return}
                                                    if value != theme!.numberOfCards{
                                                        theme = store.changeNumbersOfPair(theme!, numbersOfPair: numbersOfPair)
                                                    }
                                                }
                        .onAppear{
                            numbersOfPair = theme!.numberOfCards
                        }
                }
                Section(header:Text("Color")){
                    ColorPicker("Theme Color",selection: $themeColor)
                        .onAppear{
                            themeColor = Color(theme!.color)
                        }
                        .onChange(of: themeColor, perform:{ value in
                            store.changeThemeColor(theme!,color:value)
                        })
                        
                }
            }
            .alert(isPresented: $editorAlert){
                Alert(title: Text("Alert"), message: Text(errorMsg), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func limitText(_ upper: Int) {
        if emoji.count > upper {
            emoji = String(emoji.prefix(upper))
        }
    }
    
    var height: CGFloat {
        CGFloat((theme!.emojis.count-1)/6) * 70 + 70
    }
    let fontSize : CGFloat = 40
}

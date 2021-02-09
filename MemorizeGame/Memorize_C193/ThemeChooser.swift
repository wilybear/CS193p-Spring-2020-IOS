//
//  ThemeChooser.swift
//  Memorize_C193
//
//  Created by 김현식 on 2021/02/04.
//

import SwiftUI
import Combine

struct ThemeChooser: View {
    @EnvironmentObject var store: ThemeStore
    @State private var editMode:EditMode = .inactive
    @State private var showThemeEditor = false
    @State private var selecteTheme: Theme? = nil
    
    //presentationMode is not inherited from the presenter view, so the presenter didn't know that the modal is already closed
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
      
        NavigationView{
            List{
                ForEach(store.themes){ theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))
                                    .navigationTitle(theme.name)
                    ) {
                        ZStack{
                            if editMode.isEditing{
                                ThemeText(theme: theme)
                                    .onTapGesture {
                                        if editMode == .active{
                                            selecteTheme = theme
                                            showThemeEditor = true
                                        }
                                    }
                            }else{
                                ThemeText(theme: theme)
                            }
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    indexSet.map{store.themes[$0]}.forEach{ theme in
                        store.removeTheme(theme)
                    }
                })
                
            }
            .sheet(isPresented: $showThemeEditor){
                ThemeEditor(theme: $selecteTheme)
            }
            .navigationTitle("Memory Game")
            .navigationBarItems(leading: Button(action: {
                store.addTheme(Theme.defautlTheme)
                    }, label: {
                        Image(systemName: "plus").imageScale(.large)
                    }), trailing: EditButton().frame(height:98,alignment: .trailing))
            .environment(\.editMode, $editMode)
            
        }
     
    }
    private func tapToOpenSheetGesture()-> some Gesture{
        TapGesture()
            .onEnded{
           
        }
    }
}



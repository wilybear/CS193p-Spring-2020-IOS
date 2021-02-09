//
//  ThemeStore.swift
//  Memorize_C193
//
//  Created by 김현식 on 2021/02/04.
//

import SwiftUI
import Combine

class ThemeStore: ObservableObject{
    @Published private(set) var themes:[Theme] = []
    private var autosave: AnyCancellable?
    private let defaultKey = "MermorizeGameThemeStore"
    
    func addTheme(_ theme: Theme){
        themes.append(theme)
    }
    
    func removeTheme(_ theme: Theme){
        themes.remove(at: themes.firstIndex(of: theme)!)
    }
    
    func renameTheme(_ theme: Theme, newName: String)->Theme?{
        for index in themes.indices.filter({ themes[$0].id == theme.id}){
            themes[index].name = newName
            return themes[index]
        }
        return nil
    }
    
    func addEmojis(_ theme: Theme, emoji: String)->Theme?{
        for index in themes.indices.filter({ themes[$0].id == theme.id}){
            if themes[index].emojis.contains(emoji){
                return nil
            }else{
                themes[index].emojis.append(emoji)
                return themes[index]
            }
        }
        return nil
    }
    
    func removeEmoji(_ theme: Theme, emoji: String)->Theme?{
        for index in themes.indices.filter({ themes[$0].id == theme.id}){
            guard themes[index].emojis.count > 2 else {
                return nil
            }
            if let selected = themes[index].emojis.firstIndex(of: emoji){
                themes[index].emojis.remove(at: selected)
                if themes[index].emojis.count < themes[index].numberOfCards{
                    themes[index].numberOfCards -= 1
                }
                return themes[index]
            }
        }
        return nil
    }
    
    func changeNumbersOfPair(_ theme: Theme, numbersOfPair: Int)->Theme?{
        for index in themes.indices.filter({ themes[$0].id == theme.id}){
            themes[index].numberOfCards = numbersOfPair
            return themes[index]
        }
        return nil
    }
    
    func changeThemeColor(_ theme: Theme, color: Color){
        for index in themes.indices.filter({ themes[$0].id == theme.id}){
            let uiCol = UIColor(color)
            themes[index].color = uiCol.rgb
        }
    }
    
    init(){
        if let data = UserDefaults.standard.data(forKey: defaultKey){
            if let decodedData = try?JSONDecoder().decode([Theme].self, from: data){
                themes = decodedData
            }
        }else{
            themes = Theme.themes
        }
        
        print("\(themes)")
        autosave = $themes.sink{ themes in
            if let data = try?JSONEncoder().encode(themes){
                UserDefaults.standard.set(data, forKey:self.defaultKey)
            }
        }
    }
    
}


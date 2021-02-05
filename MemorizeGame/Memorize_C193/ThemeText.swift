//
//  ThemeText.swift
//  Memorize_C193
//
//  Created by 김현식 on 2021/02/04.
//

import SwiftUI

struct ThemeText: View {
    var theme: Theme
    
    var body: some View {
        VStack(alignment: .leading){
            Text(theme.name)
                .font(.largeTitle)
                .foregroundColor(Color(theme.color))
            HStack{
                Text(detailInfo(theme))
                    .font(.caption)
            }
        }
    }
    
    func detailInfo(_ theme: Theme) -> (String){
        theme.emojis.count == theme.numberOfCards ?
            "All of \(theme.emojis.joined(separator: " "))" : "\(theme.numberOfCards) pairs from \(theme.emojis.joined(separator: " "))"
    }
}

struct ThemeText_Previews: PreviewProvider {
    static let sport = Theme(name: "sport", color: .init(red: 0, green: 102/255, blue: 204/255, alpha: 1), emojis: ["⚽️","🏀","🏈","⛳️","🏏"],numberOfCards: 5)
   
    static var previews: some View {
        ThemeText(theme: sport)
    }
}

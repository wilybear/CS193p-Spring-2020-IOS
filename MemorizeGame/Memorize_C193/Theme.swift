//
//  Theme.swift
//  Memorize_C193
//
//  Created by 김현식 on 2021/01/30.
//

import SwiftUI

struct Theme : Codable{
    var name: String
    var color: UIColor.RGB
    var emojis: [String]
    var numberOfCards: Int {
        emojis.count
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }

    static var themes = [halloween, animal, face, sport]
    
    static let halloween = Theme(name: "halloween", color: .init(red: 204/255, green: 0, blue: 0, alpha: 1), emojis: ["🎃","👻","👾","🥵","👹","🤖"])
    static let animal = Theme(name: "animal", color: .init(red: 153/255, green: 255/255, blue: 153/255, alpha: 1), emojis: ["🐶","🐱","🐭","🐹","🐼","🐮","🐷"])
    static let face = Theme(name: "face", color: .init(red: 255/255, green: 102/255, blue: 0, alpha: 1), emojis: ["😀","🤪","😛","😇","☺️","😌","🥰","😎"])
    static let sport = Theme(name: "sport", color: .init(red: 0, green: 102/255, blue: 204/255, alpha: 1), emojis: ["⚽️","🏀","🏈","⛳️","🏏"])
    
}


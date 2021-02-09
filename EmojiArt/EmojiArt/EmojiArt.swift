//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by 김현식 on 2021/01/25.
//

import Foundation

struct EmojiArt : Codable{
    var backgroundURL: URL?
    var emojis = [Emoji]()
    //we can't make emojis private(set) because we want user to change position(x,y) values
    
    struct Emoji: Identifiable, Codable, Hashable{
        let text: String
        var x: Int  //offset from center
        var y: Int  //offset from center
        var size: Int
        var id:Int      // UUID() //unique ID
        
        //nobody can create an Emoji except Emoji itself
        //fileprivate make this private to this file
        fileprivate init(text: String, x: Int, y: Int, size: Int, id:Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    //failable initializer
    init?(json: Data?) {
        if json != nil, let newEmojiArt = try? JSONDecoder().decode(EmojiArt.self, from: json!){
            self = newEmojiArt
        } else {
            return nil

        }    }
    init(){
        
    }
    private var uniqueEmojiId = 0
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int){
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }


    
    
}

//
//  Set+ToggleMatching.swift
//  EmojiArt
//
//  Created by 김현식 on 2021/01/29.
//

import SwiftUI

extension Set where Element: Identifiable {
    mutating func toggleMatching(_ element: Element){
        if contains(matching: element){
            remove(element)
        }else{
            insert(element)
        }
    }
}

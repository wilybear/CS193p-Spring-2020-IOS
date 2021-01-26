//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by 김현식 on 2021/01/26.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View{
        Group{
            if uiImage != nil{
                Image(uiImage:uiImage!)
            }
        }
    }
}

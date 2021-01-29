//
//  View+If.swift
//  EmojiArt
//
//  Created by 김현식 on 2021/01/29.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `conditionalIf`<Transform: View>(_ condition: Bool,transform: (Self) -> Transform) -> some View {
    if condition {
        transform(self)
    } else {
        self
        }
    }
}

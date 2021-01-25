//
//  Array+Identifiable.swift
//  Memorize_C193
//
//  Created by 김현식 on 2021/01/10.
//

import Foundation


extension Array where Element: Identifiable{
    func firstIndex(matching: Element)-> Int?{
        for index in 0..<self.count{
            if self[index].id == matching.id{
                return index
            }
        }
        return nil
    }
}

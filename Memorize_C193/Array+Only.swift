//
//  Array+Only.swift
//  Memorize_C193
//
//  Created by 김현식 on 2021/01/13.
//

import Foundation

extension Array{
    var only:Element?{
        count == 1 ? first : nil
    }
}

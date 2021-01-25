//
//  Grid.swift
//  Memorize_C193
//
//  Created by 김현식 on 2021/01/09.
//

import SwiftUI

//generic structure example
//grid container
struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    
    //escaping closure : it is going to escape from initializer without getting called
    //change them to reference type and have pointers to them.
    //avcid memory cycle (keyword)
    init( _ items: [Item], viewForItem:@escaping (Item)->ItemView){
        self.items = items
        self.viewForItem = viewForItem
    }
    var body: some View {
        GeometryReader{ geometry in
            let layout :GridLayout = GridLayout(itemCount: items.count, in: geometry.size)
            ForEach(items) {item in
                let index = items.firstIndex(matching: item)!
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height:layout.itemSize.height)
                    .position(layout.location(ofItemAt: index))
            }
        }
    }
    
   
}
//Group {...}like zstack its viewbuilder, but do nothing, x lay out or position out views
//
//struct Grid_Previews: PreviewProvider {
//    static var previews: some View {
//        Grid()
//    }
//}
	

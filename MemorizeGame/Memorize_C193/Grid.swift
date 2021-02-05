//
//  Grid.swift
//  Memorize_C193
//
//  Created by 김현식 on 2021/01/09.
//

import SwiftUI

extension Grid where Item: Identifiable, ID == Item.ID {
    init( _ items: [Item],viewForItem:@escaping (Item)->ItemView){
        self.init(items,id: \Item.id , viewForItem: viewForItem)
    }
    
}

//generic structure example
//grid container
struct Grid<Item, ID,ItemView>: View where ID: Hashable ,ItemView: View {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    private var id: KeyPath<Item, ID>
    
    //escaping closure : it is going to escape from initializer without getting called
    //change them to reference type and have pointers to them.
    //avcid memory cycle (keyword)
    init( _ items: [Item], id: KeyPath<Item,ID>, viewForItem:@escaping (Item)->ItemView){
        self.items = items
        self.id = id
        self.viewForItem = viewForItem
    }
    var body: some View {
        GeometryReader{ geometry in
            let layout :GridLayout = GridLayout(itemCount: items.count,nearAspectRatio: 0.75 ,in: geometry.size)
            ForEach(items, id: id) { item in
                let index = items.firstIndex(where:{ item[keyPath: id] == $0[keyPath: id] })
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height:layout.itemSize.height)
                    .position(layout.location(ofItemAt: index!))
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
	

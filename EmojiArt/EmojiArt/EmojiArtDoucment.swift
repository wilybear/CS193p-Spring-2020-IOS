//
//  EmojiArtDoucment.swift
//  EmojiArt
//
//  Created by 김현식 on 2021/01/25.
//

import SwiftUI
import Combine

class EmojiArtDocument : ObservableObject{
    static let pallete = "🍉🍇🍓🥭"
    
    @Published private var emojiArt: EmojiArt
    
    @Published private(set) var backgroundImage : UIImage?
    private static let untitled =  "EmojiArDocument.Untitled"
    
    private var autosaveCancellable : AnyCancellable?
    private var fetchImageCancellable : AnyCancellable?
    
    init(){
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        autosaveCancellable = $emojiArt.sink{ emojiArt in
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
        fetchBackgroundImageData()
    }
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK: - Intent(s)
    func addEmoji(_ emoji: String, at location:CGPoint, size: CGFloat){
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize){
        if let index = emojiArt.emojis.firstIndex(matching: emoji){
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat){
        if let index = emojiArt.emojis.firstIndex(matching: emoji){
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size)*scale).rounded(.toNearestOrEven))
        }
    }
    func removeEmoji(_ emoji: EmojiArt.Emoji){
        if let index = emojiArt.emojis.firstIndex(matching: emoji){
            emojiArt.emojis.remove(at: index)
        }
    }
    
    var backgroundURL: URL?{
        get{
            emojiArt.backgroundURL
        }
        set{
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }
    
    private func fetchBackgroundImageData(){
        backgroundImage = nil
        if let url = emojiArt.backgroundURL{
            fetchImageCancellable?.cancel()
            fetchImageCancellable  = URLSession.shared.dataTaskPublisher(for: url)
                .map{data, urlResponse in UIImage(data: data)}
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
                .assign(to: \.backgroundImage, on: self)
        }	
    }
    
    
}

extension EmojiArt.Emoji{
    var fontSize: CGFloat {CGFloat(self.size)}
    var location: CGPoint {CGPoint(x: CGFloat(x), y: CGFloat(y))}
}

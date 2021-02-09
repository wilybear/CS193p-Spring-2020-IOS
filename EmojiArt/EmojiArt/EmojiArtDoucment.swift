//
//  EmojiArtDoucment.swift
//  EmojiArt
//
//  Created by 김현식 on 2021/01/25.
//

import SwiftUI
import Combine

class EmojiArtDocument : ObservableObject, Hashable, Identifiable{
    
    static func == (lhs: EmojiArtDocument, rhs: EmojiArtDocument) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let pallete = "🍉🍇🍓🥭"
    
    @Published private var emojiArt: EmojiArt
    
    @Published private(set) var backgroundImage : UIImage?
    
    private var autosaveCancellable : AnyCancellable?
    private var fetchImageCancellable : AnyCancellable?

    @Published var steadyStateZoomScale: CGFloat = 1.0
    @Published var steadyStatePanOffset: CGSize = .zero
    @Published var steadyStateDragOffset: CGSize = .zero
    
    init(id: UUID? = nil){
        self.id = id ?? UUID()
        let defaultKey = "EmojiArtDocument.\(self.id.uuidString)"
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey:defaultKey)) ?? EmojiArt()
        autosaveCancellable = $emojiArt.sink{ emojiArt in
            UserDefaults.standard.set(emojiArt.json, forKey: defaultKey)
        }
        fetchBackgroundImageData()
    }
    
    var url: URL? {
        didSet{
            save(emojiArt)
        }
    }
    
    init(url: URL){
        self.id = UUID()
        self.url = url
        self.emojiArt = EmojiArt(json: try? Data(contentsOf: url)) ?? EmojiArt()
        fetchBackgroundImageData()
        autosaveCancellable = $emojiArt.sink { emojiArt in
            self.save(emojiArt)
        }
    }
    
    private func save(_ emojiArt: EmojiArt){
        if url != nil {
            try? emojiArt.json?.write(to: url!)
        }
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
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = emojiArt.backgroundURL?.imageURL { // NOTE: added ?.imageURL here in L14 to fix up filesystem url
            fetchImageCancellable?.cancel()
            fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { data, urlResponse in UIImage(data: data) }
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

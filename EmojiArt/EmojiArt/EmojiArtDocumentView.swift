//
//  ContentView.swift
//  EmojiArt
//
//  Created by 김현식 on 2021/01/25.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    @State private var selectedEmojis :Set<EmojiArt.Emoji> = []
    @State private var chosenPalette: String = ""
    
    var body: some View {
        VStack {
            HStack{
                PaletteChooser(document: document, chosenPallete: $chosenPalette	)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(chosenPalette.map { String($0) }, id: \.self) { emoji in
                            Text(emoji)
                                .font(Font.system(size: defaultEmojiSize))
                                .onDrag { NSItemProvider(object: emoji as NSString) }
                        }
                    }
                }
                .onAppear{chosenPalette = document.defaultPalette}
            }
            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
                        OptionalImage(uiImage: document.backgroundImage)
                            .scaleEffect(zoomScale)
                            .offset(panOffset)
                    )
                        .gesture(doubleTapToZoom(in: geometry.size))
                    if isLoading{
                        Image(systemName: "hourglass").imageScale(.large).spinning()
                    }else{
                        ForEach(document.emojis) { emoji in
                            Text(emoji.text)
                                // using conditionalIf extension
                                .conditionalIf(selectedEmojis.contains(matching: emoji)) { $0.overlay(Rectangle().stroke(Color.green, lineWidth: 2))}
                                .font(animatableWithSize: emoji.fontSize * zoomScale(for: emoji))
                                .position(position(for: emoji, in: geometry.size))
                                .offset(dragOffset(for: emoji))
                                .onTapGesture {selectedEmojis.toggleMatching(emoji)}
                                .onLongPressGesture {
                                    document.removeEmoji(emoji)
                                    selectedEmojis.remove(emoji)
                                }
                                .gesture(emojiDragGesture())
                        }
                    }
                }
                .clipped()
                .gesture(panGesture())
                // .exclusively
                .gesture(zoomGesture().exclusively(before: tapToClearSelectedEmojis()))
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onReceive(document.$backgroundImage){ image in
                    zoomToFit(image, in: geometry.size)
                }
                .onDrop(of: ["public.image","public.text"], isTargeted: nil) { providers, location in
                    // SwiftUI bug (as of 13.4)? the location is supposed to be in our coordinate system
                    // however, the y coordinate appears to be in the global coordinate system
                    var location = CGPoint(x: location.x, y: geometry.convert(location, from: .global).y)
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height)
                    location = CGPoint(x: location.x / zoomScale, y: location.y / zoomScale)
                    return drop(providers: providers, at: location)
                }
            }
        }
    }
    
    var isLoading: Bool{
        document.backgroundURL != nil && document.backgroundImage == nil
    }
    
    
    @State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    private var zoomScale: CGFloat {
        selectedEmojis.isEmpty ? steadyStateZoomScale * gestureZoomScale : steadyStateZoomScale
    }
    
    private func zoomScale(for emoji:EmojiArt.Emoji) -> CGFloat {
        selectedEmojis.contains(matching: emoji) ? steadyStateZoomScale * gestureZoomScale : zoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { finalGestureScale in
                if selectedEmojis.isEmpty{
                    steadyStateZoomScale *= finalGestureScale
                }else{
                    selectedEmojis.forEach{ emoji in
                        document.scaleEmoji(emoji, by: finalGestureScale)
                    }
                }
            }
    }
    
    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
        }
        .onEnded { finalDragGestureValue in
            steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
        }
    }
    
    @State private var steadyStateDragOffset: CGSize = .zero
    @GestureState private var gestureDragOffset: CGSize = .zero
    
    private func dragOffset(for emoji:EmojiArt.Emoji) -> CGSize{
        selectedEmojis.contains(matching: emoji) ? (steadyStateDragOffset + gestureDragOffset) * zoomScale : steadyStateDragOffset
    }
    
    private func emojiDragGesture() -> some Gesture {
        DragGesture()
            .updating($gestureDragOffset) { latestDragGestureValue, gestureDragOffset, transaction in
                gestureDragOffset = latestDragGestureValue.translation / zoomScale
        }
        .onEnded { finalDragGestureValue in
            selectedEmojis.forEach{ emoji in
                document.moveEmoji(emoji, by: finalDragGestureValue.translation / zoomScale)
            }
        }
    }

    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func tapToClearSelectedEmojis() -> some Gesture{
            TapGesture()
                .onEnded{
                    selectedEmojis.removeAll()
                }
        }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
        
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width/2, y: location.y + size.height/2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        return location
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            document.backgroundURL = url
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                document.addEmoji(string, at: location, size: defaultEmojiSize)
            }
        }
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}

//
//  EmojiArtDocument.swift
//  Emoji-Art
//
//  Created by Captain Harris on 9/7/23.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
	@Published private var emojiArt = EmojiArt()
	
	var emojis: [Emoji] {
		emojiArt.emojis
	}
	
	var background: URL? {
		emojiArt.background
	}
	
	// MARK: - INTENTS
	
	func setBackground(_ url: URL?) {
		emojiArt.background = url
	}
	
	func addEmoji(_ emoji: String, at position: Emoji.Position, size: CGFloat) {
		emojiArt.addEmoji(emoji, at: position, size: Int(size))
	}
	
	func move(_ emoji: Emoji, by offset: CGOffset) {
		let existingPosition = emojiArt[emoji].position
		emojiArt[emoji].position = Emoji.Position(
			x: existingPosition.x + Int(offset.width),
			y: existingPosition.y - Int(offset.height)
		)
	}
	
	func move(emojiWithId id: Emoji.ID, by offset: CGOffset) {
		if let emoji = emojiArt[id] {
			move(emoji, by: offset)
		}
	}
	
	func resize(_ emoji: Emoji, by scale: CGFloat) {
		emojiArt[emoji].size = Int(CGFloat(emojiArt[emoji].size) * scale)
	}
	
	func resize(emojiWithId id: Emoji.ID, by scale: CGFloat) {
		if let emoji = emojiArt[id] {
			resize(emoji, by: scale)
		}
	}
}

extension EmojiArt.Emoji {
	var font: Font {
		Font.system(size: CGFloat(size))
	}
}

// using cartesian coord system
extension EmojiArt.Emoji.Position {
	func `in`(_ geometry: GeometryProxy) -> CGPoint {
		let center = geometry.frame(in: .local).center
		return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
	}
}

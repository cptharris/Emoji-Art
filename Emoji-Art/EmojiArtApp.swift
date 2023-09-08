//
//  EmojiArtApp.swift
//  Emoji-Art
//
//  Created by Captain Harris on 9/7/23.
//

import SwiftUI

typealias Emoji = EmojiArt.Emoji

@main
struct EmojiArtApp: App {
	@StateObject var defaultDocument = EmojiArtDocument()
	
	var body: some Scene {
		WindowGroup {
			EmojiArtDocumentView(document: defaultDocument)
		}
	}
}

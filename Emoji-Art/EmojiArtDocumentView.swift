//
//  EmojiArtDocumentView.swift
//  Emoji-Art
//
//  Created by Captain Harirs on 9/8/23.
//

import SwiftUI

struct EmojiArtDocumentView: View {
	@ObservedObject var document: EmojiArtDocument
	
	private let emojis = "👻🍎😃🤪☹️🤯🐶🐭🦁🐵🦆🐝🐢🐄🐖🌲🌴🌵🍄🌞🌎🔥🌈🌧️🌨️☁️⛄️⛳️🚗🚙🚓🚲🛺🏍️🚘✈️🛩️🚀🚁🏰🏠❤️💤⛵️"
	
	private let paletteEmojiSize: CGFloat = 40
	
	var body: some View {
		VStack(spacing: 0) {
			documentBody
			
			ScrollingEmojis(emojis)
				.font(.system(size: paletteEmojiSize))
				.padding(.horizontal)
				.scrollIndicators(.hidden)
		}
	}
	
	private var documentBody: some View {
		GeometryReader { geometry in
			ZStack {
				Color.white
				documentContents(in: geometry)
					.scaleEffect(zoom * gestureZoom)
					.offset(pan + gesturePan)
			}
			.gesture(panGesture.simultaneously(with: zoomGesture))
			.dropDestination(for: StUrlData.self) { sturldatas, location in
				return drop(sturldatas, at: location, in: geometry)
			}
		}
	}
	
	@State private var zoom: CGFloat = 1
	@State private var pan: CGOffset = .zero
	
	@GestureState private var gestureZoom: CGFloat = 1
	@GestureState private var gesturePan: CGOffset = .zero
	
	private var zoomGesture: some Gesture {
		MagnificationGesture()
			.updating($gestureZoom) { value, gestureZoom, _ in
				gestureZoom = value
			}
			.onEnded { value in
				zoom *= value
			}
	}
	
	private var panGesture: some Gesture {
		DragGesture()
			.updating($gesturePan) { value, gesturePan, _ in
				gesturePan = value.translation
			}
			.onEnded { value in
				pan += value.translation
			}
	}
	
	@ViewBuilder private func documentContents(in geometry: GeometryProxy) -> some View {
		AsyncImage(url: document.background)
			.position(Emoji.Position.zero.in(geometry))
		ForEach(document.emojis) { emoji in
			Text(emoji.string)
				.font(emoji.font)
				.position(emoji.position.in(geometry))
		}
	}
	
	// MARK: - DRAG-N-DROP
	
	private func drop(_ sturldatas: [StUrlData], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
		for sturldata in sturldatas {
			switch sturldata {
			case .url(let url):
				document.setBackground(url)
				return true
			case .string(let emoji):
				document.addEmoji(
					emoji,
					at: emojiPosition(at: location, in: geometry),
					size: paletteEmojiSize / zoom
				)
				return true
			default:
				break
			}
		}
		return false
	}
	
	private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
		let center = geometry.frame(in: .local).center
		return Emoji.Position(
			x: Int((location.x - center.x - pan.width) / zoom),
			y: Int(-(location.y - center.y - pan.height) / zoom)
		)
	}
}

struct ScrollingEmojis: View {
	let emojis: [String]
	
	init(_ emojis: String) {
		self.emojis = emojis.uniqued.map(String.init)
	}
	
	var body: some View {
		ScrollView(.horizontal) {
			HStack {
				ForEach(emojis, id: \.self) { emoji in
					Text(emoji)
						.draggable(emoji)
				}
			}
		}
	}
}

struct EmojiArtDocumentView_Previews: PreviewProvider {
	static var previews: some View {
		EmojiArtDocumentView(document: EmojiArtDocument())
	}
}

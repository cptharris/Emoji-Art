//
//  Extensions.swift
//  Emoji-Art
//
//  Created by Caleb Harris on 9/7/23.
//

import Foundation

extension CGRect {
	var center: CGPoint {
		CGPoint(x: midX, y: midY)
	}
	init(center: CGPoint, size: CGSize) {
		self.init(origin: CGPoint(x: center.x-size.width/2, y: center.y-size.width/2), size: size)
	}
}

extension String {
	
	/// Removes any duplicate characters, but preserves order.
	var uniqued: String {
		reduce(into: "") { sofar, element in
			if !sofar.contains(element) {
				sofar.append(element)
			}
		}
	}
}

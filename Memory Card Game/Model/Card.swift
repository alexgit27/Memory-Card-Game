//
//  Card.swift
//  Memory Card Game
//
//  Created by Alexandr on 07.10.2021.
//

import UIKit

class Card {
	
	//MARK: - Properties
	var id: String
	var shown: Bool = false
	var artworkURL: UIImage!
	var opened: Bool = false
	var isMatched = false
	
	static var allCards = [Card]()
	
	//MARK: - Initializer
	init(image: UIImage) {
		self.id = UUID().uuidString
		self.shown = false
		self.artworkURL = image
	}
	
	init(card: Card) {
		self.id = card.id
		self.shown = card.shown
		self.artworkURL = card.artworkURL
	}
}

//MARK: - Methods
extension Card {
	func equals(card: Card) -> Bool {
		return card.id == id
	}
	
	func copy() -> Card {
		return Card(card: self)
	}
}

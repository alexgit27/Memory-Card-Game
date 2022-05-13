//
//  APIClient.swift
//  Memory Card Game
//
//  Created by Alexandr on 08.10.2021.
//

import UIKit

typealias CardsArray = [Card]

// MARK: - APIClient
class APIClient {

	//MARK: - Properties
	static let shared = APIClient()
	
	private init() {}
	
	static var defaultCardImages:[UIImage] = [
		UIImage(named: "1")!,
		UIImage(named: "2")!,
		UIImage(named: "3")!,
		UIImage(named: "4")!,
		UIImage(named: "5")!,
		UIImage(named: "6")!,
		UIImage(named: "7")!,
		UIImage(named: "8")!,
		UIImage(named: "9")!,
		UIImage(named: "10")!,
		UIImage(named: "11")!,
		UIImage(named: "12")!,
		UIImage(named: "13")!
		
	]
	
	//MARK: - Methods
	func getCardImages(countImages: Int, completion: ((CardsArray) -> ())?) {
		var cards = CardsArray()
		let cardImages = APIClient.defaultCardImages
		
		for index in 0...countImages - 1 {
			let card = Card(image: cardImages[index])
			let copy = card.copy()
			
			cards.append(card)
			cards.append(copy)
		}
		
		completion!(cards)
	}
}

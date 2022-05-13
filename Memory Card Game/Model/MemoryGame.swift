//
//  MemoryGame.swift
//  Memory Card Game
//
//  Created by Alexandr on 07.10.2021.
//

import UIKit

// MARK: - MemoryGameProtocol
protocol MemoryGameProtocol {
	func memoryGameDidStart(_ game: MemoryGame)
	func memoryGameDidEnd(_ game: MemoryGame)
	func memoryGame(_ game: MemoryGame, showCards cards: [Card])
	func memoryGame(_ game: MemoryGame, hideCards cards: [Card])
	func turnOnButtonNext()
}
	
// MARK: - MemoryGame
class MemoryGame {
	
	// MARK: - Properties
	var delegate: MemoryGameProtocol?
	var cards:[Card] = [Card]()
	var cardsShown:[Card] = [Card]()
	var isPlaying: Bool = false
	var show: Bool = false
	
	// MARK: - Methods
	func newGame(cardsArray:[Card]) -> [Card] {
		cards = shuffleCards(cards: cardsArray)
		isPlaying = true
	
		delegate?.memoryGameDidStart(self)
		
		return cards
	}
	
	func restartGame() {
		isPlaying = false
		
		cards.removeAll()
		cardsShown.removeAll()
	}

	func cardAtIndex(_ index: Int) -> Card? {
		if cards.count > index {
			return cards[index]
		} else {
			return nil
		}
	}

	func indexForCard(_ card: Card) -> Int? {
		for index in 0...cards.count-1 {
			if card === cards[index] {
				return index
			}
		}
		return nil
	}
	
	func didSelectCard(_ card: Card?) {
		guard let card = card else { return }
		delegate?.memoryGame(self, showCards: [card])

		if unmatchedCardShown() {
			let unmatched = unmatchedCard()!
			if card.equals(card: unmatched) {
				card.opened = true
				unmatched.opened = true
				
				cardsShown.append(card)
			} else {
				let secondCard = cardsShown.removeLast()
				secondCard.opened = false
				
				let delayTime = DispatchTime.now() + 1.5
				DispatchQueue.main.asyncAfter(deadline: delayTime) {
					self.delegate?.memoryGame(self, hideCards:[card, secondCard])
					}
				}
		} else {
			cardsShown.append(card)
			card.opened = true
		}
		
		if cardsShown.count == cards.count {
			delegate?.turnOnButtonNext()
		}
	}
	
	 func endGame() {
		isPlaying = false
		delegate?.memoryGameDidEnd(self)
	}
	
	private func unmatchedCardShown() -> Bool {
		return cardsShown.count % 2 != 0
	}

	func unmatchedCard() -> Card? {
		let unmatchedCard = cardsShown.last
		return unmatchedCard
	}

	private func shuffleCards(cards:[Card]) -> [Card] {
		var randomCards = cards
		randomCards.shuffle()
		
		return randomCards
	}
}

//
//  GameController.swift
//  Memory Card Game
//
//  Created by Alexandr on 08.10.2021.
//

import UIKit
import GoogleMobileAds

class GameController: UIViewController {

	//MARK: - Properties
	@IBOutlet weak var levelLabel: UILabel!
	@IBOutlet weak var bannerView: GADBannerView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var nextButton: UIButton!
	
	private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
	
	var countImages = 7
	let game = MemoryGame()
	var cards = [Card]()
	
	//MARK: - Methods
	override func viewDidLoad() {
        super.viewDidLoad()
		
		nextButton.isEnabled = false
		nextButton.alpha = 0.5
		
		configureAds()
		
		game.delegate = self
		collectionView.delegate = self
		collectionView.dataSource = self
		
		APIClient.shared.getCardImages(countImages: countImages) { cardsArray in
			self.cards = cardsArray
			self.setupNewGame()
		}
		
		if UserDefaults.standard.bool(forKey: "userOpenedLevels") {}
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		if game.isPlaying {
			resetGame()
		}
	}
	private func configureAds() {
		if !UserDefaults.standard.bool(forKey: "userRemovedAds") {
			//		bannerView.adUnitID = "ca-app-pub-8823462613333616/2076860895"
			bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
			bannerView.rootViewController = self
			bannerView.load(GADRequest())
			bannerView.delegate = self
		}
	}
	
	private func setupNewGame() {
		cards = game.newGame(cardsArray: self.cards)
		collectionView.reloadData()
	}
	
	private func resetGame() {
		game.restartGame()
		setupNewGame()
		nextButton.isEnabled = false
		nextButton.alpha = 0.5
	}
    
	//MARK: - Actions
	@IBAction private func nextButtonAction(_ sender: Any) {
		if countImages == 4 {
			if !UserDefaults.standard.bool(forKey: "userOpenedLevels") {
				let alert = UIAlertController(title: "You can open more levels", message: "Buy!", preferredStyle: .alert)
				alert.addAction(.init(title: "OK", style: .default, handler: nil))
				self.present(alert, animated: true, completion: nil)
				return
			}
		} else if countImages == 13 {
			let alert = UIAlertController(title: "Congratulations!", message: "You won!", preferredStyle: .alert)
			alert.addAction(.init(title: "OK", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
			return
		}
		
		game.endGame()
		APIClient.shared.getCardImages(countImages: countImages) { cardsArray in
			self.cards = cardsArray
			self.setupNewGame()
		}
		
		levelLabel.text = "Level: \(countImages)"
	}
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension GameController: UICollectionViewDelegate, UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cards.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCellView
		
		guard let card = game.cardAtIndex(indexPath.item) else { return cell }
		cell.card = card
		
		if card.opened {
			cell.showCard(true, animted: false)
		} else {
			cell.showCard(false, animted: false)
		}

		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! CardCellView
		
		if cell.shown { return }
		game.didSelectCard(cell.card)
		
		collectionView.deselectItem(at: indexPath, animated:true)
	}
	
}

//MARK: - MemoryGameProtocol
extension GameController: MemoryGameProtocol{
	func turnOnButtonNext() {
		nextButton.isEnabled = true
		nextButton.alpha = 1
	}
	
	func memoryGameDidStart(_ game: MemoryGame) {
		collectionView.reloadData()
	}
	
	func memoryGame(_ game: MemoryGame, showCards cards: [Card]) {
		for card in cards {
			guard let index = game.indexForCard(card) else { continue }
			guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as? CardCellView else { return }
			cell.showCard(true, animted: true)
		}
	}
	
	func memoryGame(_ game: MemoryGame, hideCards cards: [Card]) {
		for card in cards {
			guard let index = game.indexForCard(card) else { continue }
			guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as? CardCellView else { return }
			cell.showCard(false, animted: true)
		}
	}
	
	func memoryGameDidEnd(_ game: MemoryGame) {
		countImages += 1
		resetGame()
	}
}

//MARK: - UICollectionViewDelegateFlowLayout
extension GameController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let paddingSpace = Int(sectionInsets.left) * 4
		let availableWidth = Int(view.frame.width) - paddingSpace
		let widthPerItem = availableWidth / 2
		
		return CGSize(width: widthPerItem, height: widthPerItem)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return sectionInsets
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return sectionInsets.left
	}
}

//MARK: - GADBannerViewDelegate
extension GameController: GADBannerViewDelegate {
	func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
		print("Banner view")
	}
	
	func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
		print("Baner View: \(error.localizedDescription)")
	}
}


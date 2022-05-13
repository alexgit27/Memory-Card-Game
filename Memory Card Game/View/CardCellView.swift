//
//  CardCellView.swift
//  Memory Card Game
//
//  Created by Alexandr on 08.10.2021.
//

import UIKit

class CardCellView: UICollectionViewCell {
	
	// MARK: - Properties
	@IBOutlet weak var frontImageView: UIImageView!
	@IBOutlet weak var backImageView: UIImageView!

	var card: Card? {
		didSet {
			guard let card = card else { return }
			frontImageView.image = card.artworkURL

			frontImageView.layer.cornerRadius = 5.0
			backImageView.layer.cornerRadius = 5.0

			frontImageView.layer.masksToBounds = true
			backImageView.layer.masksToBounds = true
		}
	}

	var shown: Bool = false

	// MARK: - Methods

	
	func showCard(_ show: Bool, animted: Bool) {
		frontImageView.isHidden = false
		backImageView.isHidden = false
		shown = show

		if animted {
			if show {
				UIView.transition(
					from: backImageView,
					to: frontImageView,
					duration: 0.5,
					options: [.transitionFlipFromRight, .showHideTransitionViews],
					completion: { (finished: Bool) -> () in
				})
			} else {
				UIView.transition(
					from: frontImageView,
					to: backImageView,
					duration: 0.5,
					options: [.transitionFlipFromRight, .showHideTransitionViews],
					completion:  { (finished: Bool) -> () in
				})
			}
		} else {
			if show {
				bringSubviewToFront(frontImageView)
				backImageView.isHidden = true
			} else {
				bringSubviewToFront(backImageView)
				frontImageView.isHidden = true
			}
		}
	}
}

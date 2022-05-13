//
//  PurchaceController.swift
//  Memory Card Game
//
//  Created by Alexandr on 09.10.2021.
//

import UIKit

class PurchaceController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		addObservers()
    }
	
	
	//MARK: - Methods
	private func addObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(completeRemoveAds), name: NSNotification.Name(IAPIdentifiers.removeAds.rawValue), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(completedOpenMoreLevels), name: NSNotification.Name(IAPIdentifiers.openMoreLevels.rawValue), object: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	//MARK: - Actions
	@objc private func completeRemoveAds() {
		UserDefaults.standard.set(true, forKey: "userRemovedAds")
	}
	
	@objc private func completedOpenMoreLevels() {
		UserDefaults.standard.set(true, forKey: "userOpenedLevels")
	}
    
	@IBAction func openMoreLevelsTapped(_ sender: UIButton) {
		let purchaseId = IAPIdentifiers.openMoreLevels.rawValue
		IAPManager.shared.purchase(productWith: purchaseId)
	}
	
	@IBAction func removeAdsTapped(_ sender: UIButton) {
		let purchaseId = IAPIdentifiers.removeAds.rawValue
		IAPManager.shared.purchase(productWith: purchaseId)	}
}

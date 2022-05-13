//
//  IAPManager.swift
//  Memory Card Game
//
//  Created by Alexandr on 09.10.2021.
//

import StoreKit

class IAPManager: NSObject {
	
	//MARK: - Properties
	static let productNotificationIdentifier = "IAPManagerProductIdentifier"
	static let shared = IAPManager()
	var products: [SKProduct] = []
	let paymentQueue = SKPaymentQueue.default()
	
	//MARK: - Methods
	private override init() {}
	
	func setupPurchases(completion: @escaping(Bool) -> Void) {
		if SKPaymentQueue.canMakePayments() {
			paymentQueue.add(self)
			completion(true)
			return
		}
		completion(false)
	}
	
	 func getProducts() {
		let identifiers: Set = [IAPIdentifiers.removeAds.rawValue, IAPIdentifiers.openMoreLevels.rawValue]
		
		let productRequest = SKProductsRequest(productIdentifiers: identifiers)
		productRequest.delegate = self
		productRequest.start()
	}
	
	 func purchase(productWith identifier: String) {
		guard let product = products.filter({$0.productIdentifier == identifier}).first else { return }
		let payment = SKPayment(product: product)
		paymentQueue.add(payment)
	}
	
	 func restoreCompletedTransactions() {
		paymentQueue.restoreCompletedTransactions()
	}
}

//MARK: - SKPaymentTransactionObserver
extension IAPManager: SKPaymentTransactionObserver {
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		for transaction in transactions {
			switch transaction.transactionState {
			case .deferred: break
			case .purchasing: break
			case .failed: failed(transaction: transaction)
			case .purchased: completed(transaction: transaction)
			case .restored: restored(transaction: transaction)
			default: return
			}
		}
	}
	
	private func failed(transaction: SKPaymentTransaction) {
		if let transactionError = transaction.error as NSError? {
			if transactionError.code != SKError.paymentCancelled.rawValue {
				print("Error transaction: \(transaction.error!.localizedDescription)")
			}
		}
		paymentQueue.finishTransaction(transaction)
	}
	
	private func completed(transaction: SKPaymentTransaction) {
		NotificationCenter.default.post(name: NSNotification.Name(transaction.payment.productIdentifier), object: nil)
		paymentQueue.finishTransaction(transaction)
	}
	
	private func restored(transaction: SKPaymentTransaction) {
		paymentQueue.finishTransaction(transaction)
	}
}

//MARK: - SKProductsRequestDelegate
extension IAPManager: SKProductsRequestDelegate {
	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		self.products = response.products
	}
}

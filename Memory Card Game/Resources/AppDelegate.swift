//
//  AppDelegate.swift
//  Memory Card Game
//
//  Created by Alexandr on 07.10.2021.
//

import UIKit
import GoogleMobileAds
import AppsFlyerLib


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var conversionData: [AnyHashable: Any] = [:]
	
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		//MARK: IAP
		let iap = IAPManager.shared
		iap.setupPurchases { success in
			print("Setup Purchases: \(success)")
		}
		iap.getProducts()

		//MARK: ADS
		GADMobileAds.sharedInstance().start(completionHandler: nil)
		
		//MARK: AppsFlyer
		AppsFlyerLib.shared().appsFlyerDevKey = "B7Cz9XvtY7dPwqYrSfXYxN"
		AppsFlyerLib.shared().appleAppID = "1589586314"
		
		AppsFlyerLib.shared().isDebug = true
		AppsFlyerLib.shared().delegate = self
		AppsFlyerLib.shared().start()

//		NotificationCenter.default.addObserver(self, selector: #selector(sendLaunch), name: NSNotification.Name(UIApplication.didBecomeActiveNotification.rawValue), object: nil)
		
		return true
	}
	
	@objc func sendLaunch() {
		AppsFlyerLib.shared().start()
	}


	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}


}

//MARK: - AppsFlyerLibDelegate
extension AppDelegate: AppsFlyerLibDelegate {
	func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
			self.conversionData = installData
	}
	
	func onConversionDataFail(_ error: Error) {
		print("Error onConversionDataFail: \(error.localizedDescription))")
	}
	
}

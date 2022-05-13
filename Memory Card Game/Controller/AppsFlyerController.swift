//
//  AppsFlyerController.swift
//  Memory Card Game
//
//  Created by Alexandr on 13.10.2021.
//

import UIKit
import AppsFlyerLib

class AppsFlyerController: UIViewController {

	//MARK: Properties
	@IBOutlet weak var tableView: UITableView!
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	private var conversionDataKeys: [AnyHashable] = []
	private var conversionDataValues: [Any] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//MARK: Fetch Data
		self.conversionDataKeys.append("appsFlyerUID")
		self.conversionDataValues.append(AppsFlyerLib.shared().getAppsFlyerUID())
		let data = self.appDelegate.conversionData
		
		for (key, value) in data {
			self.conversionDataKeys.append(key)
			self.conversionDataValues.append(value)
		}
    }
}

//MARK: -  UITableViewDelegate, UITableViewDataSource
extension AppsFlyerController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return conversionDataValues.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "flyerCell", for: indexPath)
		
		let value = conversionDataValues[indexPath.row]
		let key = conversionDataKeys[indexPath.row]
		cell.textLabel?.text = String(describing: key)
		cell.detailTextLabel?.text = String(describing: value)
		cell.detailTextLabel?.numberOfLines = 0
		
		cell.textLabel?.font = .systemFont(ofSize: 25, weight: .bold)
		cell.detailTextLabel?.font = .systemFont(ofSize: 22, weight: .medium)
		
		return cell
	}
}

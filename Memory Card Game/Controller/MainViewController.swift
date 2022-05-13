//
//  ViewController.swift
//  Memory Card Game
//
//  Created by Alexandr on 07.10.2021.
//

import UIKit

struct ResponseIpInfo: Codable {
	let country: String
}

class MainViewController: UIViewController {
	
	//MARK: - Properties
	@IBOutlet weak var playButtonOutlet: UIButton!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var activityAndicator: UIActivityIndicatorView!
	
	let urlString = "https://ipinfo.io/json?token=e7dc28dfd8412f"
	var segueIdentifierPerform = ""
	
	//MARK: -  Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController?.navigationBar.tintColor = .black
		playButtonOutlet.isHidden = true
		activityAndicator.hidesWhenStopped = true
		activityAndicator.startAnimating()
		
		getSegueIdentifier()
	}

	private func getSegueIdentifier() {
		let url = URL(string: urlString)
		guard let url = url else { return }
		getUserLocation(url: url) { [weak self] result, error in
			guard result != nil, error == nil else { return }
			DispatchQueue.main.async {
				self?.activityAndicator.stopAnimating()
				self?.descriptionLabel.isHidden = true
				self?.playButtonOutlet.isHidden = false
				
				if result == "RU" {
					self?.segueIdentifierPerform = "webView"
				} else {
					self?.segueIdentifierPerform = "game"
				}
			}
		}
	}
		
	private func getUserLocation(url: URL, completion: @escaping(String?, Error?) -> Void) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data, error == nil else { return }

			do {
				let result = try JSONDecoder().decode(ResponseIpInfo.self, from: data)
				completion(result.country, nil)

			} catch {
				completion(nil, error)
			}
		}.resume()
	}


	@IBAction func lookAnalysTapped(_ sender: UIBarButtonItem) {
		performSegue(withIdentifier: "analysVC", sender: nil)
	}
	@IBAction private func playButtonTapped(_ sender: UIButton) {
		performSegue(withIdentifier: segueIdentifierPerform, sender: nil)
	}
	
	@IBAction private func proButtonTapped() {
		performSegue(withIdentifier: "proController", sender: nil)
	}
}


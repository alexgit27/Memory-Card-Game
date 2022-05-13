//
//  WebViewController.swift
//  Memory Card Game
//
//  Created by Alexandr on 08.10.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

	//MARK: - Properties
	@IBOutlet private weak var webView: WKWebView!
	
	//MARK: - Methods
	override func viewDidLoad() {
        super.viewDidLoad()

		webView.navigationDelegate = self
		
		guard let url = URL(string: "https://ru.wikipedia.org/wiki/%D0%97%D0%B0%D0%B3%D0%BB%D0%B0%D0%B2%D0%BD%D0%B0%D1%8F_%D1%81%D1%82%D1%80%D0%B0%D0%BD%D0%B8%D1%86%D0%B0") else { return }
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
    }
}
